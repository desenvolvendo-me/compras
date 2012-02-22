class CommitmentType < ActiveRecord::Base
  attr_accessible :code, :description

  validates :code, :presence => true

  validates :code, :length => { :is => 3 }
  validates :code, :description, :presence => true
  validates :code, :description, :uniqueness => true

  filterize
  orderize :description

  def to_s
    "#{code} - #{description}"
  end
end
