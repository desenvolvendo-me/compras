class ExtendedCompanySize < Compras::Model
  attr_accessible :company_size_id, :benefited

  belongs_to :company_size
end
