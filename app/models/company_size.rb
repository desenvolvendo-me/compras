class CompanySize < Persona::CompanySize
  attr_accessible :extended_company_size_attributes

  attr_modal :name, :acronym, :number

  has_one :extended_company_size, :dependent => :destroy

  has_many :purchase_process_accreditation_creditors, :dependent => :restrict

  accepts_nested_attributes_for :extended_company_size

  delegate :benefited, :benefited?, :to => :extended_company_size, :allow_nil => true

  filterize
  orderize
end
