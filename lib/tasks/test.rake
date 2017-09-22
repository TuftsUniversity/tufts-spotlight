  # frozen_string_literal: true

require 'jettywrapper'
SolrWrapper.default_instance_options = {
  verbose: true,
  port: 8984,
  version: '6.3.0',
  instance_dir: 'solr/install'
}
require 'solr_wrapper/rake_task'

task default: ['tufts:spec']

# rubocop:disable Metrics/BlockLength
namespace :tufts do
  desc 'Execute Continuous Integration build (docs, tests with coverage)'
  task ci: :environment do
    Rake::Task['jetty:download'].invoke
    Rake::Task['jetty:unzip'].invoke
    Rake::Task['jetty:start'].invoke

    sleep(30)

    Rake::Task['tufts:configs'].invoke
    Rake::Task['db:migrate'].invoke
  end

  desc 'Runs tests inside solr wrapper'
  task spec: :environment do
    SolrWrapper.wrap do |solr|
      solr.with_collection(dir: Rails.root.join('solr/config/'), name: 'test') do
        Rake::Task['tufts:fixtures'].invoke
        Rake::Task['spec'].invoke
      end
    end
  end

  desc 'Copy config files'
  task configs: :environment do
    %w[database fedora blacklight secrets solr ldap].each do |f|
      unless File.exist?("config/#{f}.yml")
        FileUtils.cp(
          Rails.root.join("config/#{f}.yml.sample"),
          Rails.root.join("config/#{f}.yml")
        )
      end
    end
  end

  desc 'Load fixture data'
  task fixtures: :environment do
    FIXTURES = %w[
      tufts:MS054.003.DO.02108
      tufts:TBS.VW0001.000113
      tufts:TBS.VW0001.000386
      tufts:TBS.VW0001.002493
    ].freeze

    loader = ActiveFedora::FixtureLoader.new("#{Rails.root}/spec/fixtures")
    FIXTURES.each do |pid|
      puts("Refreshing #{pid}")
      ActiveFedora::FixtureLoader.delete(pid)
      loader.import_and_index(pid)
    end
  end # End task ci
  # rubocop:enable Metrics/BlockLength
end
