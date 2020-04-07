# frozen_string_literal: true

namespace :db do
  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task migrate: :environment do
    verbose = ENV['VERBOSE'] ? ENV['VERBOSE'] == 'true' : true
    version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    migrations_paths = ActiveRecord::Migrator.migrations_paths

    ActiveRecord::Migration.verbose = verbose
    ActiveRecord::Migrator.migrate(migrations_paths, version)

    if Rails.env != 'development' && Rails.env != 'test'
      Customer.where("domain LIKE '%portoseguro-ba%'").where(disabled: false).find_each do |customer|
        # Customer.where(:disabled => false).find_each do |customer|
        puts "migrating customer #{customer.domain}" if verbose

        customer.using_connection do
          ActiveRecord::Migrator.migrate(migrations_paths, version)
        end
      end
    end
  end
end
namespace :structure do
  desc 'Dump the database structure to db/structure.sql. Specify another file with DB_STRUCTURE=db/my_structure.sql'
  task dump: %i[environment load_config] do
    config = current_config
    filename = ENV['DB_STRUCTURE'] || File.join(Rails.root, 'db', 'structure.sql')
    case config['adapter']
    when /mysql/, 'oci', 'oracle'
      ActiveRecord::Base.establish_connection(config)
      File.open(filename, 'w:utf-8') { |f| f << ActiveRecord::Base.connection.structure_dump }
    when /postgresql/
      set_psql_env(config)
      search_path = config['schema_search_path']
      unless search_path.blank?
        search_path = search_path.split(',').map { |search_path_part| "--schema=#{Shellwords.escape(search_path_part.strip)}" }.join(' ')
      end
      `pg_dump -i -s -x -O -f #{Shellwords.escape(filename)} #{search_path} #{Shellwords.escape(config['database'])}`
      raise 'Error dumping database' if $CHILD_STATUS.exitstatus == 1

      File.open(filename, 'a') { |f| f << "SET search_path TO #{ActiveRecord::Base.connection.schema_search_path};\n\n" }
    when /sqlite/
      dbfile = config['database']
      `sqlite3 #{dbfile} .schema > #{filename}`
    when 'sqlserver'
      `smoscript -s #{config['host']} -d #{config['database']} -u #{config['username']} -p #{config['password']} -f #{filename} -A -U`
    when 'firebird'
      set_firebird_env(config)
      db_string = firebird_db_string(config)
      sh "isql -a #{db_string} > #{filename}"
    else
      raise "Task not supported by '#{config['adapter']}'"
    end

    if ActiveRecord::Base.connection.supports_migrations?
      File.open(filename, 'a') { |f| f << ActiveRecord::Base.connection.dump_schema_information }
    end
    db_namespace['structure:dump'].reenable
  end
end
