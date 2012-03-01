class PaymentMethod < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true
  validates :description, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end
