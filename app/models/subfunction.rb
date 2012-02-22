class Subfunction < ActiveRecord::Base
  attr_accessible :code, :description, :function_id

  belongs_to :function
  has_many :budget_allocations, :dependent => :restrict

  orderize :code
  filterize

  validates :code, :presence => true, :uniqueness => true, :numericality => true
  validates :description, :function_id, :presence => true
  validates :description, :uniqueness => true

  def to_s
    "#{code} - #{description}"
  end
end
