class NatureExpense < Compras::Model
  attr_accessible :description, :nature,:split_expenses_attributes

  has_many :split_expenses, class_name: 'SplitExpense',
           :order => :id,dependent: :destroy
  accepts_nested_attributes_for :split_expenses, allow_destroy: true

  def to_s
    "#{description}"
  end

  validates :description, :nature, presence: true, uniqueness:true
  validates_format_of :nature, :with => /^[0-9.&]*\z/

  orderize :id
  filterize

end
