class CheckingAccountStructureInformation < Compras::Model
  attr_accessible :name, :tce_code, :capability_source_id

  belongs_to :capability_source

  has_many :checking_account_structures, :dependent => :restrict

  validates :name, :tce_code, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
