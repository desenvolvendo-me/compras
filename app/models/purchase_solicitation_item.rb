class PurchaseSolicitationItem < Compras::Model
  attr_accessible :purchase_solicitation_id, :material_id,
                  :brand, :quantity, :unit_price, :lot

  attr_accessor :order

  belongs_to :purchase_solicitation
  belongs_to :material

  has_many :price_collection_proposal_items, through: :purchase_solicitation,
    conditions: proc {
      "compras_price_collection_items.material_id = #{self.material_id} and
       compras_price_collection_proposal_items.unit_price > 0" }

  delegate :reference_unit, :material_characteristic,
           :to => :material, :allow_nil => true
  delegate :annulled?, :services?,
           :to => :purchase_solicitation,
           :allow_nil => true
  delegate :budget_structure, to: :purchase_solicitation,
           prefix: true, allow_nil: true

  validates :material, :quantity, :presence => true
  validate :validate_material_characteristic, :if => :services?

  scope :by_material, lambda { |material_ids|
    material_ids = [material_ids] unless material_ids.kind_of?(Array)
    where { |item| item.material_id.in material_ids }
  }

  scope :ordered_by_lot_material, lambda{
    joins(:material).order("lot, unico_materials.description")
  }

  def self.balance_by_purchasing_unit contract_id
    joins { purchase_solicitation.department }
   .joins { purchase_solicitation.list_purchase_solicitations.licitation_process.contracts }
   .where { purchase_solicitation.list_purchase_solicitations.licitation_process.contracts.id.eq(contract_id) }
   .select("compras_purchase_solicitation_items.id as id, compras_departments.description as department").group_by(&:department)
  end

  def estimated_total_price
    (quantity || BigDecimal(0)) * (unit_price || BigDecimal(0))
  end

  def estimated_total_price_rounded
    estimated_total_price.round(2)
  end

  def average_proposal_item_price
    @average_proposal_item_price ||= price_collection_proposal_items.average(:unit_price)
  end

  def average_proposal_total_price
    (quantity || BigDecimal(0)) * (average_proposal_item_price || BigDecimal(0))
  end

  def proposal_total_price_winner
    (quantity || BigDecimal(0)) * (proposal_unit_price_winner || BigDecimal(0))
  end

  def proposal_unit_price_winner
    price_collection_proposal_winner.try(:unit_price)
  end

  def proposal_creditor_winner
    price_collection_proposal_winner.try(:creditor)
  end

  private

  def price_collection_proposal_winner
    price_collection_proposal_items.ranked_by_unit_price.first
  end

  def validate_material_characteristic
    return unless material

    unless material.service?
      errors.add(:material, :should_be_service)
    end
  end
end
