class StnOrdinance < ActiveRecord::Base
  attr_accessible :description

  has_many :expense_economic_classifications, :dependent => :restrict

  validates :description, :presence => true, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end
