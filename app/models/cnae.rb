class Cnae < Unico::Cnae
  attr_modal :name, :code

  has_many :creditors_with_main_cnae, :class_name => "Creditor", :dependent => :restrict, :foreign_key => :main_cnae_id
  has_many :companies_with_main_cnae, :class_name => "Company", :dependent => :restrict, :foreign_key => :main_cnae_id
  has_many :creditor_secondary_cnaes, :dependent => :restrict
  has_many :creditors, :through => :creditor_secondary_cnaes

  filterize
  orderize :code

  scope :cnaes_remainder, lambda { |ids| where { id.not_in ids } }

  scope :term, lambda { |q|
    where { name.like("%#{q}%") }
  }

  def to_s
    name
  end
end
