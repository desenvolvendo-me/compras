class RevenueCategory < ActiveRecord::Base
  attr_accessible :code, :description

  has_many :revenue_subcategories, :dependent => :restrict

  validates :code, :description, :presence => true
  validates :code, :uniqueness => true

  def to_s
    "#{code}"
  end
end
