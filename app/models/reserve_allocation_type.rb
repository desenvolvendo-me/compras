# encoding: utf-8
class ReserveAllocationType < ActiveRecord::Base
  attr_accessible :description, :status

  has_enumeration_for :status
  has_enumeration_for :source

  has_many :reserve_funds, :dependent => :restrict

  validates :description, :status, :presence => true
  validates :description, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end

  def licitation?
    description == "Licitação"
  end
end
