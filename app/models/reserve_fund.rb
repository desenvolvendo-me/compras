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

  def self.by_purchase_process_id(id)
    self.all(params: { by_purchase_process_id: id,
      methods: [:budget_allocation_to_s, :balance, :descriptor_to_s] })
  end
end
