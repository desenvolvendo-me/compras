class RevenueNature < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_category_id

  belongs_to :revenue_category

  validates :code, :description, :revenue_category, :presence => true
  validates :code, :uniqueness => { :scope => [:revenue_category_id] }

  def to_s
    "#{code}"
  end
end
