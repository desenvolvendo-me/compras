# frozen_string_literal: true

namespace :db do
  desc "Migrate the database (options: VERSION=x, VERBOSE=false)."
  task migrate: :environment do
    verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    migrations_paths = ActiveRecord::Migrator.migrations_paths

    ActiveRecord::Migration.verbose = verbose
    ActiveRecord::Migrator.migrate(migrations_paths, version)

    if Rails.env != "development" && Rails.env != "test"
      Customer.where("domain LIKE '%portoseguro-ba%' or domain like '%conceicaodoaraguaia-pa%'").where(disabled: false).find_each do |customer|
        # Customer.where(:disabled => false).find_each do |customer|
        puts "migrating customer #{customer.domain}" if verbose

        customer.using_connection do
          ActiveRecord::Migrator.migrate(migrations_paths, version)
        end
      end
    end
  end
end
