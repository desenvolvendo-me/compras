class PurchaseSolicitationItem < Compras::Model
  attr_accessible :purchase_solicitation_id, :material_id,
                  :brand, :quantity, :unit_price

  attr_accessor :order

  belongs_to :purchase_solicitation
  belongs_to :material

  delegate :reference_unit, :material_characteristic,
           :to => :material, :allow_nil => true
  delegate :annulled?, :services?,
           :to => :purchase_solicitation,
           :allow_nil => true

  validates :material, :quantity, :presence => true
  validates :material_id, :uniqueness => { :scope => :purchase_solicitation_id }, :allow_nil => true
  validate :validate_material_characteristic, :if => :services?

  scope :by_material, lambda { |material_ids|
    material_ids = [material_ids] unless material_ids.kind_of?(Array)
    where { |item| item.material_id.in material_ids }
  }

  def estimated_total_price
    (quantity || BigDecimal(0)) * (unit_price || BigDecimal(0))
  end

  private

  def validate_material_characteristic
    return unless material

    unless material.service?
      errors.add(:material, :should_be_service)
    end
  end
end
