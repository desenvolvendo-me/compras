class FiscalYear < ActiveRecord::Base
  attr_accessible :year

  validates :year, :presence => true, :uniqueness => { :allow_blank => true }

  filterize
  orderize :year

  def to_s
    year.to_s
  end
end
