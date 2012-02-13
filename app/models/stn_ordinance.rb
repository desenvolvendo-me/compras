class StnOrdinance < ActiveRecord::Base
  attr_accessible :description

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true

  has_many :economic_classification_of_expenditures, :dependent => :restrict

  def to_s
    description
  end
end
