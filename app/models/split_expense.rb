class SplitExpense < Compras::Model
  belongs_to :nature_expense
  attr_accessible :code, :description, :function_account

  validates :code,:description,presence: true

  orderize :id
  filterize

  scope :term, lambda { |q|
    where { description.like("#{q}%") }
  }

  def to_s
    "#{nature_expense.nature } #{nature_expense.to_s.titleize} - #{description}"
  end

end
