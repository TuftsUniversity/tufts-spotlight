# frozen_string_literal: true

if Rails.env.test?
  SolrWrapper.default_instance_options = {
    verbose: true,
    port: 8985,
    version: '6.3.0',
    instance_dir: 'solr/install'
  }
end
require 'solr_wrapper/rake_task'

task default: ['tufts:spec']

# hrubocop:disable Metrics/BlockLength
namespace :tufts do
  desc 'Execute Continuous Integration build (docs, tests with coverage)'
  task ci: :environment do
    Rake::Task['tufts:configs'].invoke
    Rake::Task['db:migrate'].invoke
  end

  desc 'Runs tests inside solr wrapper'
  task spec: :environment do
    SolrWrapper.wrap do |solr|
      solr.with_collection(dir: Rails.root.join('solr/config/'), name: 'hydra-test') do
        Rake::Task['spec'].invoke
      end
    end
  end

  desc 'Copy config files'
  task configs: :environment do
    %w[blacklight solr ldap].each do |f|
      next if File.exist?(Rails.root.join('config', "#{f}.yml"))
      FileUtils.cp(
        Rails.root.join('config', "#{f}.yml.sample"),
        Rails.root.join('config', "#{f}.yml")
      )
    end
  end
end
