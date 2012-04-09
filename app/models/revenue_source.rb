class RevenueSource < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_subcategory_id

  belongs_to :revenue_subcategory

  has_many :revenue_rubrics, :dependent => :restrict

  validates :code, :description, :revenue_subcategory, :presence => true
  validates :code, :uniqueness => { :scope => :revenue_subcategory_id }, :allow_blank => true

  delegate :code, :to => :revenue_subcategory, :prefix => true, :allow_nil => true
  delegate :revenue_source_code, :to => :revenue_subcategory, :allow_nil => true
  delegate :revenue_category_code, :to => :revenue_subcategory, :allow_nil => true

  orderize :id
  filterize

  def to_s
    code.to_s
  end
end
