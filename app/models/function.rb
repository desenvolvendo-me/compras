class Function < Compras::Model
  attr_accessible :code, :regulatory_act_id, :description

  belongs_to :regulatory_act

  has_many :subfunctions, :dependent => :restrict

  delegate :vigor_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  validates :description, :code, :presence => true
  validates :code, :uniqueness   => { :scope => :regulatory_act_id, :message => :taken_for_regulatory_act },
                   :numericality => true,
                   :allow_blank  => true

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
