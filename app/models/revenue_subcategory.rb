class RevenueSubcategory < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_category_id

  belongs_to :revenue_category

  has_many :revenue_sources, :dependent => :restrict

  validates :code, :description, :revenue_category, :presence => true
  validates :code, :uniqueness => { :scope => :revenue_category_id }, :allow_blank => true

  orderize :id
  filterize

  def to_s
    code.to_s
  end
end
