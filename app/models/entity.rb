class Entity < ActiveRecord::Base
  attr_accessible :name

  has_many :expense_economic_classifications, :dependent => :restrict
  has_many :organogram_configurations, :dependent => :restrict

  orderize
  filterize

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    name
  end
end
