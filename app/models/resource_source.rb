class ResourceSource < Compras::Model
  attr_accessible :code, :name, :number_convention, :year

  has_many :expenses

  validates :code, :name, presence: true, uniqueness:true
  validates :year, presence: true, :mask => "9999", :allow_blank => true
  validates :code, :mask => "9999", :allow_blank => true
  validates :number_convention, :mask => "999999999", :allow_blank => true

  orderize "created_at"
  filterize

  scope :by_contract, lambda { |q|
    joins(expenses:[:contract_financials])
        .where(compras_contract_financials:{contract_id: q})
  }
  scope :by_id, lambda { |q|
    unless q.blank?
      where(id: q)
    end
  }


  def to_s
    "#{code}"
  end

end
