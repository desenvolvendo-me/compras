class Capability < ActiveRecord::Base
  attr_accessible :entity_id, :year, :description, :goal, :kind

  has_enumeration_for :kind, :with => CapabilityKind

  belongs_to :entity

  validates :year, :mask => '9999'

  orderize :description
  filterize

  def to_s
    description
  end
end
