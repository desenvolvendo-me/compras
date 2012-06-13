class PledgeHistoric < Compras::Model
  attr_accessible :description, :entity_id, :year

  has_enumeration_for :source

  belongs_to :entity

  has_many :pledges, :dependent => :restrict

  validates :description, :presence => true
  validates :entity, :presence => true, :unless => Proc.new { |ph| ph.source == Source::DEFAULT }
  validates :year, :presence => true, :unless => Proc.new { |ph| ph.source == Source::DEFAULT }
  validates :year, :mask => "9999", :allow_blank => true

  orderize :description
  filterize

  def to_s
    description
  end
end
