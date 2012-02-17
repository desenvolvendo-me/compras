class Capability < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :goal, :kind, :status

  has_enumeration_for :kind, :with => CapabilityKind

  belongs_to :entity

  validates :year, :mask => '9999'
  validates :status, :presence => true

  has_enumeration_for :status, :create_helpers => true, :with => CapabilityStatus

  orderize :description
  filterize

  def to_s
    description
  end
end
