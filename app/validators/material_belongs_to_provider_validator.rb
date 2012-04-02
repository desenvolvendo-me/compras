class MaterialBelongsToProviderValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    record.direct_purchase_budget_allocations.each do |dpba|
      dpba.items.each do |item|
        unless value.materials.include?(item.material) ||
               value.materials_classes.include?(item.material.materials_class) ||
               value.materials_groups.include?(item.material.materials_group)
          item.errors.add(:material, :must_belong_to_selected_provider)
        end
      end
    end
  end
end
