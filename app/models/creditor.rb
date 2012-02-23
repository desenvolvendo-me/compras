class Creditor < ActiveRecord::Base
  attr_accessible :name, :status, :entity_id

  has_enumeration_for :status

  belongs_to :entity

  orderize
  filterize

  validates :name, :status, :entity, :presence => true

  def to_s
    name
  end
end
