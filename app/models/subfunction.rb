class Subfunction < ActiveRecord::Base
  attr_accessible :code, :description, :function_id, :entity_id, :year

  belongs_to :function
  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict

  validates :description, :entity, :year, :function, :code, :presence => true

  with_options :allow_blank => true do |allowed_blank|
    allowed_blank.validates :code, :numericality => true
    allowed_blank.validates :code, :description, :uniqueness => true
    allowed_blank.validates :year, :mask => '9999'
  end

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
