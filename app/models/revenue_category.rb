class RevenueCategory < ActiveRecord::Base
  attr_accessible :code, :description

  validates :code, :description, :presence => true
  validates :code, :uniqueness => true

  def to_s
    "#{code}"
  end
end
