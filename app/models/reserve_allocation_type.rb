# encoding: utf-8
class ReserveAllocationType < Compras::Model
  attr_accessible :description, :status

  has_enumeration_for :status
  has_enumeration_for :source

  has_many :reserve_funds, :dependent => :restrict

  validates :description, :status, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  orderize :description
  filterize

  def self.default_status
    Status::ACTIVE
  end

  def to_s
    description
  end

  def licitation?
    description == "Licitação"
  end
end
