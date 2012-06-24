class PledgeHistoric < Compras::Model
  attr_accessible :descriptor_id, :description

  has_enumeration_for :source

  belongs_to :descriptor

  has_many :pledges, :dependent => :restrict

  validates :description, :presence => true
  validates :descriptor, :presence => true, :unless => Proc.new { |ph| ph.source == Source::DEFAULT }

  orderize :description
  filterize

  def to_s
    description
  end
end
