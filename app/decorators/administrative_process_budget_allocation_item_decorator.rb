class AdministrativeProcessBudgetAllocationItemDecorator < Decorator
  attr_modal :material, :quantity, :unit_price

  attr_data 'id' => :id, 'material' => :material, 'quantity' => :quantity, 'unit_price' => :unit_price

  def winner_proposal_total_price
    helpers.number_to_currency component.winner_proposal_total_price if component.winner_proposal_total_price
  end
end
