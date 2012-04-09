class GovernmentAction < ActiveRecord::Base
  attr_accessible :year, :description, :status, :entity_id

  has_enumeration_for :status, :create_helpers => true

  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict

  validates :description, :status, :entity, :year, :presence => true
  validates :year, :numericality => true, :mask => '9999', :allow_blank => true

  orderize :description
  filterize

  def to_s
    description
  end
end
