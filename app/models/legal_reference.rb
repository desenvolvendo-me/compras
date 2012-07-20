class LegalReference < Compras::Model
  attr_accessible :description, :law, :article, :paragraph, :sections, :synopsis

  attr_modal :description, :law, :article, :paragraph, :sections

  has_many :direct_purchases, :dependent => :restrict

  validates :description, :law, :article, :presence => true
  validates :law, :article, :paragraph, :numericality => true, :allow_blank => true

  orderize :description
  filterize

  def to_s
    description
  end
end
