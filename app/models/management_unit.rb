class ManagementUnit < ActiveRecord::Base
  attr_accessible :description, :acronym, :status, :entity_id, :year

  orderize :description
  filterize

  has_many :pledges, :dependent => :restrict
  belongs_to :entity

  validates :year, :mask => "9999"
  validates :entity, :year, :description, :acronym, :status, :presence => true

  has_enumeration_for :status, :create_helpers => true, :with => ManagementUnitStatus

  def to_s
    description
  end
end
