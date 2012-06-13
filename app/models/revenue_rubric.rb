class RevenueRubric < Compras::Model
  attr_accessible :code, :description, :revenue_source_id

  belongs_to :revenue_source

  has_many :revenue_natures, :dependent => :restrict

  validates :code, :description, :revenue_source, :presence => true
  validates :code, :uniqueness => { :scope => :revenue_source_id }, :allow_blank => true

  orderize :id
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
