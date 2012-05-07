module Rails
  module Generators
    class CrudGenerator < NamedBase
      include ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, :type => 'array', :default => [], :banner => 'field:type field:type'

      class_option :singular, :type => 'string', :desc => 'Singular name for i18n'

      class_option :plural, :type => 'string', :desc => 'Plural name for i18n'

      class_option :dashboard, :type => 'string', :desc => 'Dashboard that will have this crud'

      class_option :fields, :type => 'hash', :desc => 'Attribute names for i18n'

      check_class_collision :suffix => 'Controller'

      hook_for :orm, :as => :model do |invoked|
        invoke invoked, ARGV, :fixture => false
      end

      def create_controller
        template 'controller.rb', File.join('app/controllers', class_path,"#{controller_file_name}_controller.rb")
      end

      hook_for :helper do |invoked|
        invoke invoked, [ controller_name ], :test_framework => false
      end

      def create_views
        empty_directory File.join('app/views', controller_file_path)

        available_views.each do |filename|
          template filename, File.join('app/views', controller_file_path, filename)
        end
      end

      def create_singular_locale
        template "singular_locale.yml", File.join('config/locales', "#{singular_name}.yml")
      end

      def create_locale_to_controllers_names
        controllers_file = 'config/locales/controllers.yml'
        controllers = File.join('config/locales', 'controllers.yml')

        template('controllers.yml', controllers) unless File.exist?(controllers_file)

        in_root do
          append_file controllers_file, "    #{plural_table_name}: \"#{plural}\"\n".force_encoding("ascii-8bit")
        end
      end

      def add_resource_route
        route_config =  class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
        route_config << "resources :#{file_name.pluralize} do\n"
        route_config << "    collection do\n"
        route_config << "      get :filter\n"
        route_config << "      get :modal\n"
        route_config << "    end\n"
        route_config << "  end\n"
        route_config << " end" * class_path.size

        route route_config
      end

      def create_blueprint
        blueprint_file = File.join('spec/blueprints', class_path, "#{plural_name}.rb")
        template 'blueprint.rb', blueprint_file
      end

      def create_request_spec
        request_file = File.join('spec/requests', class_path, "#{plural_name}_spec.rb")
        template 'request.rb', request_file
      end

      def create_decorator
        decorator_file = File.join('app/decorators', class_path, "#{singular_name}_decorator.rb")
        template 'decorator.rb', decorator_file
      end

      def create_decorator_spec
        decorator_spec_file = File.join('spec/decorators', class_path, "#{singular_name}_decorator_spec.rb")
        template 'decorator_spec.rb', decorator_spec_file
      end

      protected

      def dashboard
        options["dashboard"] || "Cadastro Geral"
      end

      def plural
        options["plural"] || plural_name
      end

      def singular
        options["singular"] || singular_name
      end

      def fields
        options["fields"] || attributes.map do |attribute|
          [attribute.name, attribute.human_name]
        end
      end

      def available_views
        %w(_form.html.erb)
      end

      def associations?
        associations.any?
      end

      def associations
        attributes.select { |attribute| attribute.reference? }
      end
    end
  end
end
