class NoDuplicationValidator < ActiveModel::EachValidator
  # Validates that the collection does not have more than one item with the specified attribute value
  #
  # Examples
  #
  # class Purchase < ActiveRecord::Base
  #   validates :curricular_panel_disciplines, :no_duplication => :discipline_id
  #   validates :direct_purchases, :no_duplication => :material_id
  #   validates :administrative_process_budget_allocations, :no_duplication => :budget_allocation_id
  # end
  #
  def validate_each(record, attribute, value)
    return if value.blank?

    attribute_to_validate = options[:with]
    message               = options[:message]
    scope                 = options[:scope]            || []
    allow_nil             = options[:allow_nil]        || false
    if_condition          = options[:if_condition]     || lambda { |obj| true  }
    unless_condition      = options[:unless_condition] || lambda { |obj| false }

    value = value.reject(&:marked_for_destruction?)

    value = value.group_by do |p|
      group = []
      scope.each { |field| group << p.send(field) }
      group
    end

    value.each do |scope, elements|
      single_items = []

      elements.each do |element|
        attr_value = element.send(attribute_to_validate)

        next unless if_condition.call(element)

        next if unless_condition.call(element)

        if single_items.include? attr_value
          record.errors.add(attribute, message)
          element.errors.add(attribute_to_validate, :taken)
        end

        if allow_nil
          single_items << attr_value
        else
          single_items << attr_value unless attr_value.nil?
        end
      end
    end
  end
end
