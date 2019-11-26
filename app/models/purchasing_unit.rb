class PurchasingUnit < Compras::Model
  attr_accessible :cnpj, :code, :name, :situation, :starting

  orderize "id DESC"
  filterize

  has_enumeration_for :situation, :with => PurchasingUnitSituation, :create_helpers => true

  validates :code, :name, presence: true
  validates :code,uniqueness: true, if: :unique_situation_active?
  validates :code, :mask => "9999"

  def to_s
    name
  end

  def unique_situation_active?
    purchasing = PurchasingUnit.where(code: self.code).
        where(situation: 'active')
    purchasing.blank? || purchasing[0].id == self.id ? false:true
  end

end
