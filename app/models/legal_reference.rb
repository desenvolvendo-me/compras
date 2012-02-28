class LegalReference < ActiveRecord::Base
  attr_accessible :description, :law, :article, :paragraph, :sections, :synopsis

  attr_modal :description, :law, :article, :paragraph, :sections, :synopsis

  validates :description, :law, :article, :presence => true
  validates :law, :article, :paragraph, :numericality => true

  orderize :description
  filterize

  def to_s
    description
  end
end
