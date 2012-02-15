class StnOrdinance < ActiveRecord::Base
  attr_accessible :description

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true

  has_many :expense_economic_classifications, :dependent => :restrict

  def to_s
    description
  end
end
