class GovernmentAction < ActiveRecord::Base
  attr_accessible :year, :description, :status, :entity_id

  orderize :description
  filterize

  belongs_to :entity

  validates :description, :status, :entity_id, :presence => true
  validates :year, :presence => true, :numericality => true, :mask => '9999'

  has_enumeration_for :status, :create_helpers => true, :with => GovernmentActionStatus

  def to_s
    description
  end
end
