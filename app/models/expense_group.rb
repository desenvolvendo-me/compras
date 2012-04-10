class ExpenseGroup < ActiveRecord::Base
  attr_accessible :code, :description

  validates :code, :description, :presence => true
  validates :code, :uniqueness => true, :allow_blank => true

  def to_s
    code.to_s
  end
end
