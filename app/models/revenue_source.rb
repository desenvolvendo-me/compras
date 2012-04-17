class RevenueSource < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_subcategory_id

  belongs_to :revenue_subcategory

  has_many :revenue_rubrics, :dependent => :restrict
  has_many :revenue_natures, :dependent => :restrict

  validates :code, :description, :revenue_subcategory, :presence => true
  validates :code, :uniqueness => { :scope => :revenue_subcategory_id }, :allow_blank => true

  orderize :id
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
