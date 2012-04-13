class RevenueAccounting < ActiveRecord::Base
  attr_accessible :entity_id, :revenue_nature_id, :capability_id, :code, :year

  belongs_to :entity
  belongs_to :revenue_nature
  belongs_to :capability

  delegate :docket, :to => :revenue_nature, :allow_nil => true, :prefix => true

  validates :entity, :year, :revenue_nature, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :revenue_nature_id, :uniqueness => true, :allow_blank => true

  orderize :code
  filterize

  def to_s
    code
  end
end
