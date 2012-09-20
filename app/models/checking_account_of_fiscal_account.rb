class CheckingAccountOfFiscalAccount < Compras::Model
  attr_accessible :function, :main_tag, :name, :tce_code

  has_many :checking_account_structures, :dependent => :restrict
  has_many :account_plans, :dependent => :restrict

  validates :tce_code, :name, :main_tag, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
