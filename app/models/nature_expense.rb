class NatureExpense < Compras::Model
  attr_accessible :description, :nature

  orderize :id
  filterize

  def to_s
    "#{description}"
  end

  validates :description, :nature, presence: true, uniqueness:true
  validates_format_of :nature, :with => /^[0-9.&]*\z/

end
