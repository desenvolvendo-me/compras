class PledgeCategory < ActiveRecord::Base
  attr_accessible :description, :status

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true
  validates :status, :presence => true

  has_enumeration_for :status, :create_helpers => true, :with => PledgeCategoryStatus
  has_enumeration_for :source, :create_helpers => true

  def to_s
    description
  end
end
