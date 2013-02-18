module CustomData
  extend ActiveSupport::Concern

  module ClassMethods
    def reload_custom_data
      return unless self.custom_attributes

      self.custom_attributes.each do |key|
        send(:attr_accessible, key)

        define_method(key) do
          custom_data && custom_data[key]
        end

        define_method("#{key}=") do |value|
          self.custom_data = (custom_data || {}).merge(key => value)
        end
      end

      serialize :custom_data, ActiveRecord::Coders::Hstore
    end

    def custom_attributes
      return unless custom_data

      custom_data.map(&:data).map { |value| value.parameterize("_") }
    end

    def change_custom_data_name(name_was, name)
      where { custom_data.not_eq(nil) }.find_each do |instance|
        custom_data = instance.custom_data

        value = custom_data.delete(name_was)
        custom_data = custom_data.merge(name => value)

        instance.custom_data = custom_data
        instance.save!
      end
    end

    def custom_data
      return {} unless Prefecture.exists?

      class_name = name.underscore
      current_state_id = Prefecture.last.state_id

      CustomizationData.joins { customization }.where {
        customization.model.eq(class_name) &
        customization.state_id.eq(current_state_id)
      }
    end
  end

  def validate_custom_data
    presence_validator
  end

  private

  delegate :normalized_data, :to => :customization_data, :allow_nil => true

  def presence_validator
    return unless self.class.custom_data

    self.class.custom_data.each do |item|
      date_validator(item)

      if item.required
        string_presence_validator(item)
        numeric_presence_validator(item)
        date_presence_validator(item)
      end
    end
  end

  def string_presence_validator(item)
    return unless item.string? || item.text? || item.select?

    if custom_data[item.normalized_data].empty?
      errors.add(item.normalized_data.to_sym, :blank)
    end
  end

  def numeric_presence_validator(item)
    return unless item.decimal? || item.integer?

    if BigDecimal(custom_data[item.normalized_data]) == BigDecimal("0")
      errors.add(item.normalized_data.to_sym, :blank)
    end
  end

  def date_presence_validator(item)
    return unless item.date?

    if custom_data[item.normalized_data].empty?
      errors.add(item.normalized_data.to_sym, :blank)
    end
  end

  def date_validator(item)
    return unless item.date?

    begin
      custom_data[item.normalized_data].to_date
    rescue ArgumentError
      errors.add(item.normalized_data.to_sym, :invalid)
    end
  end
end
