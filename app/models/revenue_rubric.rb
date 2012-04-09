class RevenueRubric < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_source_id

  belongs_to :revenue_source

  has_many :revenue_natures, :dependent => :restrict

  validates :code, :description, :revenue_source, :presence => true
  validates :code, :uniqueness => { :scope => :revenue_source_id }, :allow_blank => true

  delegate :code, :to => :revenue_source, :prefix => true, :allow_nil => true
  delegate :revenue_subcategory_code, :to => :revenue_source, :allow_nil => true
  delegate :revenue_category_code, :to => :revenue_source, :allow_nil => true

  orderize :id
  filterize

  def full_code
    [
      revenue_category_code,
      revenue_subcategory_code,
      revenue_source_code,
      code,
    ].reject(&:blank?).join('.')
  end

  def to_s
    code.to_s
  end
end
