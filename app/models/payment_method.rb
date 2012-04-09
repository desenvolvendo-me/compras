class PaymentMethod < ActiveRecord::Base
  attr_accessible :description

  has_many :direct_purchases, :dependent => :restrict
  has_many :licitation_processes, :dependent => :restrict

  validates :description, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  orderize :description
  filterize

  def to_s
    description
  end
end
