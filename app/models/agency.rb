class Agency < Compras::Model
  attr_accessible :name, :number, :digit, :bank_id, :phone, :fax, :email

  belongs_to :bank

  has_many :bank_accounts, :dependent => :restrict

  validates :name, :number, :digit, :bank, :presence => true
  validates :email, :mail => true, :allow_blank => true
  validates :phone, :fax, :mask => "(99) 9999-9999", :allow_blank => true

  orderize
  filterize

  scope :bank_id, lambda { |bank_id| where(:bank_id => bank_id) }

  def to_s
    name
  end
end
