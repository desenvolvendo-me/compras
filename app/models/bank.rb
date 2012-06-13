class Bank < Compras::Model
  attr_accessible :name, :code, :acronym

  has_many :agencies, :dependent => :restrict
  has_many :bank_accounts, :through => :agencies

  validates :name, :acronym, :presence => true
  validates :name, :uniqueness => { :allow_blank => true }
  validates :code, :presence => true, :length => { :maximum => 5 }

  filterize
  orderize

  def to_s
    name
  end
end
