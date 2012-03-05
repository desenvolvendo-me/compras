class Subfunction < ActiveRecord::Base
  attr_accessible :code, :description, :function_id, :entity_id, :year

  belongs_to :function
  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict

  validates :code, :presence => true, :uniqueness => true, :numericality => true
  validates :description, :entity, :year, :function, :presence => true
  validates :description, :uniqueness => true
  validates :year, :mask => '9999'

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
