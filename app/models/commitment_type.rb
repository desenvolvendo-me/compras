class CommitmentType < ActiveRecord::Base
  attr_accessible :code, :description

  has_many :pledges, :dependent => :restrict

  validates :code, :description, :presence => true, :uniqueness => true
  validates :code, :mask => '999'

  filterize
  orderize :description

  def to_s
    "#{code} - #{description}"
  end
end
