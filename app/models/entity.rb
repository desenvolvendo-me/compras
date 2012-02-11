class Entity < ActiveRecord::Base
  attr_accessible :name

  has_many :economic_classification_of_expenditures, :dependent => :restrict
  has_many :organogram_configurations, :dependent => :restrict

  orderize
  filterize

  validates :name, :presence => true
  validates :name, :uniqueness => true

  def to_s
    name
  end
end
