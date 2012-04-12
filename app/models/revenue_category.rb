class RevenueCategory < ActiveRecord::Base
  attr_accessible :code, :description

  has_many :revenue_subcategories, :dependent => :restrict

  validates :code, :description, :presence => true
  validates :code, :uniqueness => { :allow_blank => true }

  orderize :id
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
