class ReserveFund < UnicoAPI::Resources::Contabilidade::ReserveFund
  include ActiveResource::Associations
  include BelongsToResource

  attr_modal :date, :budget_allocation_id, force: true

  belongs_to :creditor

  belongs_to_resource :budget_allocation

  schema do
    date :date
    decimal :amount
  end
end
