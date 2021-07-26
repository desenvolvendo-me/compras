module Compras
  module Inputs
    class FindInput
      include ::ActionView::Helpers::NumberHelper

      attr_accessor :value, :setting, :options

      def initialize(value, setting, options = {})
        @value   = value
        @setting = setting
        @options = options
      end

      def find
        @options[:label]      = @setting.data
        @options[:required]   = @setting.required
        @options[:as]         = @setting.data_type.to_sym
        @options[:collection] = @setting.options if @setting.select?
        @options[:input_html] = { 'data-custom-data-name' => @setting.normalized_data }

        if @setting.dependency_name.present?
          @options[:input_html].merge!({ 'data-dependency' => dependency_field_id(@setting.dependency_name) })
        end

        if @setting.dependency_value.present?
          @options[:input_html].merge!({ 'data-dependency-value' => @setting.dependency_value })
        end

        if @setting.decimal?
          @options[:as] = :decimal
          @options[:input_html]['data-scale'] = 10
          @options[:input_html]['data-precision'] = 2
          @options[:input_html][:value] = number_with_precision(@value) if @value
        end

        if @setting.modal?
          @options[:modal_url] = template.send("modal_#{@setting.modal_entity.pluralize}_path")
          @options[:hidden_field] = "#{@setting.method_name}"
        end

        @options
      end

      private

      def dependency_field_id(dependency_name)
        dependency_field = lookup_chain
        dependency_field += "_#{nested_index}" if nested_index
        dependency_field += "_#{dependency_name}"
      end

      def lookup_chain
        @options[:lookup_chain].gsub("[", "_").gsub("]", "")
      end

      def nested_index
        @options[:nested_index]
      end

      def template
        @options[:template]
      end
    end
  end
end
