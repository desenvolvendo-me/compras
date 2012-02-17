class CommitmentType < ActiveRecord::Base
  attr_accessible :code, :description

  validates :code, :presence => true

  validates :code, :numericality => { :less_than_or_equal_to => 999 }
  validates :code, :uniqueness => true
  validates :description, :presence => true
  validates :description, :uniqueness => true

  filterize
  orderize :description

  def to_s
    "#{code} - #{description}"
  end
end
