class NatureExpense < Compras::Model
  attr_accessible :description, :nature,:split_expenses_attributes

  has_many :split_expenses, class_name: 'SplitExpense',
           :order => :id,dependent: :destroy
  accepts_nested_attributes_for :split_expenses, allow_destroy: true

  validates :description, :nature, presence: true, uniqueness:true

  orderize "created_at"
  filterize


end
