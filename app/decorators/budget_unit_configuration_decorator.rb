class BudgetUnitConfigurationDecorator < Decorator
  attr_modal :description, :entity_id, :regulatory_act_id

  attr_data 'mask' => :mask
end
