class NatureExpense < Compras::Model
  attr_accessible :description, :nature, :split_expenses_attributes, :year

  attr_modal :description, :nature
  
  has_many :split_expenses, class_name: 'SplitExpense',
           :order => :id,dependent: :destroy
  accepts_nested_attributes_for :split_expenses, allow_destroy: true

  validates :description, :nature, presence: true, uniqueness: { case_sensitive: false }

  validates :year, :mask => "9999", :allow_blank => true

  orderize "created_at"
  filterize

  scope :term, lambda {|q|
    where {description.like("#{q}%")}
  }

  def to_s
    description
  end

end
