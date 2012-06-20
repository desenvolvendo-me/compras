class CompanySize < Unico::CompanySize
  attr_accessible :extended_company_size_attributes

  has_one :extended_company_size, :dependent => :destroy

  accepts_nested_attributes_for :extended_company_size

  filterize
  orderize
end
