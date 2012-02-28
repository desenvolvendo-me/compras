class GovernmentProgram < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :status

  has_enumeration_for :status

  belongs_to :entity

  has_many :budget_allocations, :dependent => :restrict

  validates :entity, :year, :description, :status, :presence => true
  validates :year, :mask => '9999'

  filterize
  orderize :description

  def to_s
    description
  end
end
