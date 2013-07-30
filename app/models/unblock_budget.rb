class UnblockBudget < UnicoAPI::Resources::Contabilidade::UnblockBudget
  include ActiveResource::Associations
  include BelongsToResource
  include I18n::Alchemy

  belongs_to_resource :reserve_fund

  schema do
    decimal :amount
  end
end
