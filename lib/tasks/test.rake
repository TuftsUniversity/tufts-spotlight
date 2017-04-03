require 'jettywrapper'
SolrWrapper.default_instance_options = {
  verbose: true,
  port: 8984,
  version: "6.3.0",
  instance_dir: "solr/install"
}
require 'solr_wrapper/rake_task'

task :default => ["tufts:spec"]

namespace :tufts do

  desc "Execute Continuous Integration build (docs, tests with coverage)"
  task :ci => :environment do
    Rake::Task["jetty:download"].invoke
    Rake::Task["jetty:unzip"].invoke
    Rake::Task["jetty:start"].invoke

    sleep(30)

    Rake::Task["tufts:configs"].invoke
    Rake::Task["db:migrate"].invoke
  end

  desc "Runs tests inside solr wrapper"
  task :spec => :environment do
    SolrWrapper.wrap do |solr|
      solr.with_collection(dir: Rails.root.join("solr/config/"), name: "test") do |col|
        Rake::Task["tufts:fixtures"].invoke
        Rake::Task["spec"].invoke
      end
    end
  end

  desc 'Copy config files'
  task :configs => :environment do
    %w(database fedora blacklight secrets solr ldap).each do |f|
      FileUtils::cp(
        Rails.root.join("config/#{f}.yml.sample"),
        Rails.root.join("config/#{f}.yml")
      ) unless File.exist?("config/#{f}.yml")
    end
  end

  desc 'Load fixture data'
  task :fixtures => :environment do
    FIXTURES = %w(
      tufts:MS054.003.DO.02108
    )
#    FIXTURES = %w(
#      tufts:UA069.001.DO.UP029
#      tufts:UA069.005.DO.00272
#      tufts:UA069.005.DO.00239
#      tufts:UA069.005.DO.00339
#      tufts:UP022.001.001.00001.00003
#      tufts:UP022.001.001.00001.00004
#      tufts:UP022.001.001.00001.00005
#      tufts:UP029.003.003.00014
#      tufts:UP029.003.003.00012
#      tufts:UP029.020.031.00108
#
#      tufts:MS054.003.DO.02108
#      tufts:MS115.003.001.00001
#      tufts:MS115.003.001.00002
#      tufts:MS115.003.001.00003
#      tufts:MS122.002.001.00130
#      tufts:MS122.002.004.00025
#      tufts:MS122.002.021.00084
#      tufts:MS124.001.001.00002
#      tufts:MS124.001.001.00003
#      tufts:MS124.001.001.00006
#      tufts:PB.002.001.00001
#      tufts:PB.005.001.00001
#      tufts:RCR00001
#      tufts:RCR00613
#      tufts:RCR00728
#      tufts:TBS.VW0001.000113
#      tufts:TBS.VW0001.000386
#      tufts:TBS.VW0001.002493
#
#      tufts:UA015.012.DO.00104
#      tufts:UA069.001.DO.MS019
#      tufts:UA069.001.DO.MS043
#      tufts:UA069.001.DO.MS056
#      tufts:UA069.001.DO.MS134
#      tufts:UA069.001.DO.UA001
#      tufts:UA069.001.DO.UA015
#      tufts:UA069.005.DO.00001
#      tufts:UA069.005.DO.00026
#      tufts:UA069.005.DO.00090
#      tufts:UA069.005.DO.00094
#      tufts:ky.clerkofthehouse.1813
#      tufts:la.speakerofthehouse.1820
#      tufts:me.uscongress3.second.1825
#      tufts:sample002
#
#      tufts:MK999.999.999.99999
#      tufts:MS134.006.035.00004
#      tufts:MS190.001.00005
#      tufts:UA009.011.029.00009
#      tufts:UA015.001.003.00072.00005
#      tufts:sample007
#      tufts:ddennett-2006.00007
#      tufts:UA206.001.426.00042
#      tufts:UA084.508087359
#      tufts:MS201.002.03081
#      tufts:MS190.001.00001
#      tufts:RCR00979
#      tufts:UP226.001.001.00010.00002
#      tufts:MS123.001.001.00001
#      tufts:MS165.002.001.00012
#      tufts:12423
#      )

    loader = ActiveFedora::FixtureLoader.new("#{Rails.root}/spec/fixtures")
    FIXTURES.each do |pid|
      puts("Refreshing #{pid}")
      ActiveFedora::FixtureLoader.delete(pid)
      loader.import_and_index(pid)
    end

  end # End task ci
end
