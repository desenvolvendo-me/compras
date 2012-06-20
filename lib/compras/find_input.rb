module Compras
  class FindInput
    include ::ActionView::Helpers::NumberHelper

    attr_accessor :value, :setting, :options

    def initialize(value, setting)
      @value   = value
      @setting = setting
      @options = {}
    end

    def find
      @options[:label] = @setting.name
      @options[:collection] = @setting.names_and_ids if @setting.collection?
      @options[:as] = :boolean  if @setting.boolean?
      @options[:as] = :date     if @setting.date?
      @options[:as] = :datetime if @setting.datetime?
      @options[:as] = :integer  if @setting.integer?
      @options[:input_html] = { 'data-property-id' => @setting.id }
      @options[:disabled] = true if @setting.respond_to?(:read_only?) && @setting.read_only?

      if @setting.respond_to?(:dependency) && @setting.dependency
        @options[:input_html][:disabled] = true
        @options[:input_html]['data-dependency'] = @setting.dependency.id
        @options[:input_html]['data-dependency-id'] = @setting.dependency.property_id
      end

      if @setting.decimal?
        @options[:as] = :decimal
        @options[:input_html][:value] = number_with_delimiter(@value, :delimiter => "")
      end

      @options
    end
  end
end
