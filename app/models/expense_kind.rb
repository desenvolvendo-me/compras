class ExpenseKind < ActiveRecord::Base
  attr_accessible :description, :status

  has_enumeration_for :status, :create_helpers => true

  has_many :pledges, :dependent => :restrict

  validates :description, :uniqueness => { :allow_blank => true }
  validates :status, :description, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
