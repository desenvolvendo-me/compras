class ContractDecorator < Decorator
  attr_modal :year, :contract_number, :sequential_number, :signature_date

  def all_pledges_total_value
    helpers.number_to_currency super if super
  end
end
