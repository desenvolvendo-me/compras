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
    single_items = []

    value.reject(&:marked_for_destruction?).each do |element|
      if single_items.include?(element.send(attribute_to_validate))
        record.errors.add(attribute)
        element.errors.add(attribute_to_validate, :taken)
      end
      single_items << element.send(attribute_to_validate)
    end
  end
end
