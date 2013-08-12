class BudgetStructure < UnicoAPI::Resources::Contabilidade::BudgetStructure
  include BelongsToResource

  attr_modal :code, :description, :kind, force: true

  belongs_to_resource :parent, resource_class: BudgetStructure

  def to_s
    "#{full_code} - #{description}"
  end

  def structure_sequence
    return [self] if parent.nil?

    parent.structure_sequence << self
  end
end
