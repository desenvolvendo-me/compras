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
        @options[:as]         = :text     if @setting.text?
        @options[:as]         = :boolean  if @setting.boolean?
        @options[:as]         = :date     if @setting.date?
        @options[:as]         = :integer  if @setting.integer?
        @options[:input_html] = { 'data-custom-data-id' => @setting.id }
  
        if @setting.decimal?
          @options[:as] = :decimal
          @options[:input_html]['data-scale'] = 10
          @options[:input_html]['data-precision'] = 2
          @options[:input_html][:value] = number_with_precision(@value) if @value
        end
  
        @options
      end
    end
  end
end
