class PurchasingUnit < Compras::Model
  attr_accessible :cnpj, :code, :name, :situation, :starting

  orderize "id DESC"
  filterize

  has_enumeration_for :situation, :with => PurchasingUnitSituation, :create_helpers => true

  validates :code, :name, presence: true, uniqueness: true
  validates :code, :mask => "9999"

  def to_s
    name
  end

end
