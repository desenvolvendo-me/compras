class Function < Compras::Model
  attr_accessible :code, :regulatory_act_id, :description

  belongs_to :regulatory_act

  has_many :subfunctions, :dependent => :restrict

  delegate :vigor_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
