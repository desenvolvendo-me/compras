class Contract < Compras::Model
  attr_accessible :year, :entity_id, :contract_number, :process_number
  attr_accessible :signature_date, :end_date, :description, :kind

  has_enumeration_for :kind, :with => ContractKind, :create_scopes => true

  belongs_to :entity

  has_many :pledges, :dependent => :restrict

  validates :year, :entity, :contract_number, :process_number, :presence => true
  validates :signature_date, :end_date, :description, :kind, :presence => true
  validates :year, :mask => "9999", :allow_blank => true
  validates :end_date, :timeliness => { :after => :signature_date, :type => :date, :allow_blank => true }

  orderize :contract_number
  filterize

  def to_s
    contract_number
  end
end
