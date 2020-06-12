class PurchasingUnit < Compras::Model
  attr_accessible :cnpj, :code, :name, :situation, :starting, :billing

  orderize "id DESC"
  filterize

  has_enumeration_for :situation, :with => PurchasingUnitSituation, :create_helpers => true

  validates :code, :name, presence: true
  validates :code, uniqueness: true, if: :unique_situation_active?
  validates :code, :mask => "9999"

  scope :by_situation, lambda { |q|
    where {
      (situation.eq(q)) }
  }

  def to_s
    "#{code}: #{name}"
  end

  def unique_situation_active?
    purchasing = PurchasingUnit.where(code: self.code).
        where(situation: 'active')
    purchasing.blank? || purchasing[0].id == self.id ? false:true
  end

end
