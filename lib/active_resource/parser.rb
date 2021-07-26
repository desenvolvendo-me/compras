module ActiveResource
  module Parser
    protected

    def parse_attributes!
      schema.each do |k, v|
        if known_attributes.include?(k) && attributes[k].is_a?(String)
          @attributes[k] = parse_attribute(attributes[k], v.to_sym)
        end
      end

      self
    end

    def parse_attribute(value, object_type)
      return unless value

      case object_type
      when :integer
        value.to_i
      when :float
        value.to_f
      when :decimal
        value.to_d
      when :datetime
        value.to_datetime
      when :time, :timestamp
        value.to_time
      when :date
        value.to_date
      when :boolean
        value ==  'true'
      else
        value
      end
    end
  end
end
