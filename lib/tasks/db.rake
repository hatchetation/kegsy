require 'sequel'
require 'time'

# Snagged from https://gist.github.com/viking/1133150
# 
# Some convienent rake tasks for bootstrapping databases
# Using the standalone `sequel` gem

namespace :bundler do
  task :setup do
    require 'rubygems'
    require 'bundler/setup'
  end
end
 
task :environment, [:env] => 'bundler:setup' do |cmd, args|
  ENV["RACK_ENV"] = args[:env] || "development"
  require "kegsy/infrastructure/database.rb"
  DB = Kegsy::Infrastructure::DB
end
 
namespace :db do
  # Snagged from https://gist.github.com/DevL/4285948
  #
  # Rake task to generate empty Sequel migrations
  namespace :generate do
    desc 'Generate a timestamped, empty Sequel migration.'
    task :migration, :name do |_, args|
      if args[:name].nil?
        puts 'You must specify a migration name (e.g. rake generate:migration[create_events])!'
        exit false
      end
 
      content = "Sequel.migration do\n  up do\n    \n  end\n\n  down do\n    \n  end\nend\n"
      timestamp = DateTime.now.strftime("%Y%m%d%H%M%S")
      filename = File.join(File.dirname(__FILE__), '../../db/migrations', "#{timestamp}_#{args[:name]}.rb")
 
      File.open(filename, 'w') do |f|
        f.puts content
      end
 
      puts "Created the migration #{filename}"
    end
  end

  desc "Run database migrations"
  task :migrate, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['environment'].invoke(env)
 
    require 'sequel/extensions/migration'
    Sequel::Migrator.apply(DB, "db/migrations")
  end
 
  desc "Rollback the database"
  task :rollback, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['environment'].invoke(env)
 
    require 'sequel/extensions/migration'
    version = (row = DB[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(DB, "db/migrate", version - 1)
  end
 
  desc "Nuke the database (drop all tables)"
  task :nuke, :env do |cmd, args|
    env = args[:env] || "development"
    Rake::Task['environment'].invoke(env)

    # Disable Foreign Key assertions while we nuke the database
    DB.run("SET FOREIGN_KEY_CHECKS = 0")

    DB.tables.each do |table|
      DB.run("DROP TABLE #{table}")
    end

    # Re-enable Foreign Key assertions after we're done deleting
    DB.run("SET FOREIGN_KEY_CHECKS = 1")
  end
 
  desc "Reset the database"
  task :reset, [:env] => [:nuke, :migrate]
end