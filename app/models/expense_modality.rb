class ExpenseModality < ActiveRecord::Base
  attr_accessible :code, :description

  has_many :expense_natures, :dependent => :restrict

  validates :code, :description, :presence => true
  validates :code, :uniqueness => true, :allow_blank => true

  orderize :code
  filterize

  def to_s
    code.to_s
  end
end
