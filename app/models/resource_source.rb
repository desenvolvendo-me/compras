class ResourceSource < Compras::Model
  attr_accessible :code, :name, :number_convention, :year

  validates :code, :name, presence: true, uniqueness:true
  validates :year, presence: true, :mask => "9999", :allow_blank => true
  validates :code, :mask => "9999", :allow_blank => true
  validates :number_convention, :mask => "999999999", :allow_blank => true

  orderize "created_at"
  filterize

  scope :by_contract, lambda { |q|
    ids = Expense.joins{ contract_financials }.where{ contract_financials.contract_id.eq(q) }.pluck(:resource_source_id)
    where("id in (?)", ids)
  }

  def to_s
    "#{code}"
  end

end
