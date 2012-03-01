class Creditor < ActiveRecord::Base
  attr_accessible :name, :status, :entity_id

  has_enumeration_for :status

  belongs_to :entity

  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict

  validates :name, :status, :entity, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
