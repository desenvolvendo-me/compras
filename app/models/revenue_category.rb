class RevenueCategory < ActiveRecord::Base
  attr_accessible :code, :description

  has_many :revenue_natures, :dependent => :restrict

  validates :code, :description, :presence => true
  validates :code, :uniqueness => true

  def to_s
    "#{code}"
  end
end
