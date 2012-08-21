class CompanySize < Unico::CompanySize
  attr_accessible :extended_company_size_attributes

  attr_modal :name, :acronym, :number

  has_one :extended_company_size, :dependent => :destroy

  accepts_nested_attributes_for :extended_company_size

  delegate :benefited, :to => :extended_company_size, :allow_nil => true

  filterize
  orderize
end
