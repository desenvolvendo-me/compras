require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails
  def self.production_way?
    env.production? || env.staging? || env.training?
  end
end

module Compras
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
    #{config.root}/lib
    )
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = ['pt-BR']
    config.i18n.default_locale = 'pt-BR'
    config.i18n.locale = 'pt-BR'

    config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]

    config.encoding = "utf-8"


    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += [
        # stylesheet files
        'devise.css',
        'report.css',
        'compras/report.css',
        'compras/table_size.css',

        # javascript files
        'bidders.js',
        'bidding_schedules.js',
        'contracts.js',
        'creditor_proposal_benefited_tieds.js',
        'employees.js',
        'licitation_processes.js',
        'pledge_requests.js',
        'price_collections.js',
        'purchase_process_accreditations.js',
        'purchase_process_creditor_disqualifications.js',
        'purchase_process_proposals.js',
        'purchase_process_tradings.js',
        'purchase_process_tradings_negotiations.js',
        'purchase_solicitations.js',
        'reserve_fund_requests.js',
        'supply_orders.js',
        'supply_requests.js',
        'additive_solicitations.js',
        'expenses.js',
        'balance_adjustments.js',
        'modal_filter.js',
        'reports/balance_per_creditor',
        "select2/select2.min",
        "select2/select2_locale_pt-BR"
    ]
    # Include helpers from current controller only
    config.action_controller.include_all_helpers = false

    config.active_record.disable_implicit_join_references = false

    config.active_record.whitelist_attributes = false



    def self.redis_configuration
      if Rails.production_way?
        uri = URI.parse(ENV["REDISTOGO_URL"])
      else
        uri = URI.parse("redis://localhost:6379")
      end
    end
  end
end
