class ReserveFund < UnicoAPI::Resources::Contabilidade::ReserveFund
  include ActiveResource::Associations
  include BelongsToResource
  include I18n::Alchemy

  attr_modal :date, :budget_allocation_id, force: true

  belongs_to :creditor

  belongs_to_resource :budget_allocation

  # schema do
  #   date :date
  #   decimal :amount
  # end

  def self.by_purchase_process_id(id)
    #TODO resolver problema na api do contabilidade
    # all(params: {
    #   by_purchase_process_id: id,
    #   methods: :balance,
    #   includes: {
    #     descriptor: { methods: :to_s }
    #   }
    # })
  end
end
