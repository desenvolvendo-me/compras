class LicitationProcessRatificationItem < Compras::Model
  attr_accessible :licitation_process_ratification_id, :purchase_process_creditor_proposal_id,
    :ratificated, :purchase_process_item_id, :purchase_process_trading_item_id,
    :realignment_price_item_id

  belongs_to :licitation_process_ratification
  belongs_to :purchase_process_creditor_proposal
  belongs_to :purchase_process_trading_item
  belongs_to :purchase_process_item
  belongs_to :realignment_price_item

  has_one :licitation_process, through: :purchase_process_creditor_proposal
  has_one :creditor, through: :licitation_process_ratification

  has_many :supply_order_items

  delegate :description, :code, :reference_unit, to: :material, allow_nil: true
  delegate :identity_document, to: :creditor, allow_nil: true, prefix: true
  delegate :unit_price, :total_price,
    to: :purchase_process_creditor_proposal, allow_nil: true
  delegate :year, :process,
    to: :licitation_process, allow_nil: true, prefix: true
  delegate :material, :quantity, :lot, to: :item, allow_nil: true
  delegate :control_amount?, to: :material, allow_nil: true
  delegate :price, :total_price, to: :realignment_price_item, allow_nil: true, prefix: true
  delegate :has_realignment_price?, to: :licitation_process_ratification, allow_nil: true

  scope :creditor_id, ->(creditor_id) do
    joins { licitation_process_ratification }.
    where { licitation_process_ratification.creditor_id.eq(creditor_id) }
  end

  scope :licitation_process_id, ->(licitation_process_id) do
    joins { licitation_process_ratification }.
    where { licitation_process_ratification.licitation_process_id.eq(licitation_process_id) }
  end

  scope :purchase_process_item_material_id, ->(material_id) do
    joins { purchase_process_item.material }
         .where { purchase_process_item.material.id.eq(material_id) }
  end

  scope :by_ratificated, -> { where { ratificated.eq(true) } }

  scope :type_of_purchase_licitation, -> { joins { licitation_process }.
    where { licitation_process.type_of_purchase.eq(PurchaseProcessTypeOfPurchase::LICITATION)}
  }

  scope :by_ratification_month_and_year, lambda { |month, year|
    joins { licitation_process_ratification }.
    where(%{
      extract(month from compras_licitation_process_ratifications.ratification_date) = ? AND
      extract(year from compras_licitation_process_ratifications.ratification_date) = ?},
      month, year)
  }

  scope :by_licitation_process_and_material, lambda { |licitation_process_id, material_id|
    subquery = PurchaseProcessItem
            .select(
                "compras_purchase_process_items.id compras_item_id,
                 compras_purchase_process_items.lot, compras_purchase_process_items.unit_price,
                 compras_purchase_process_items.licitation_process_id,
                 compras_purchase_process_items.quantity,
                 unico_materials.id material_id,
                 unico_materials.description,
                 unico_materials.quantity_unit quantiade_caixa,
                 unico_materials.split_expense_id")
        .joins(:material)
        .where(unico_materials: {id: material_id}).to_sql

    select("mat.lot,
          compras_realignment_price_items.price,
          mat.licitation_process_id,
          mat.unit_price valor_cotacao,
          mat.material_id,
          mat.description,
          mat.quantity,
          compras_licitation_process_ratifications.creditor_id")
        .joins(:realignment_price_item )
    .joins("INNER JOIN (#{subquery}) as mat
            ON mat.compras_item_id = compras_realignment_price_items.purchase_process_item_id")
    .joins(:licitation_process_ratification)
    .where(mat: {licitation_process_id: licitation_process_id})
  }


  orderize "id DESC"
  filterize

  def unit_price
    realignment_price_item_price || trading_item_unit_price ||  creditor_proposal_unit_price || purchase_process_item_unit_price
  end

  def total_price
    realignment_price_item_total_price || trading_item_total_price || creditor_proposal_total_price || purchase_process_total_price
  end

  def item
    trading_item  || creditor_proposal_item || purchase_process_item
  end

  def authorized_quantity
    supply_order_items.sum(:authorization_quantity)
  end

  def authorized_value
    supply_order_items.sum(:authorization_value)
  end

  def supply_order_item_balance
    (quantity || 0) - (authorized_quantity || 0)
  end

  def supply_order_item_value_balance
    (total_price || 0) - (authorized_value || 0)
  end

  private

  def creditor_proposal_item
    purchase_process_creditor_proposal.try(:item)
  end

  def trading_item
    purchase_process_trading_item.try(:item)
  end

  def creditor_proposal_unit_price
    purchase_process_creditor_proposal.try(:unit_price)
  end

  def trading_item_unit_price
    return unless purchase_process_trading_item
    TradingItemWinner.new(purchase_process_trading_item).amount
  end

  def purchase_process_item_unit_price
    purchase_process_item.try(:unit_price)
  end

  def creditor_proposal_total_price
    purchase_process_creditor_proposal.try(:total_price)
  end

  def purchase_process_total_price
    purchase_process_item.try(:estimated_total_price)
  end

  def trading_item_total_price
    return unless (purchase_process_trading_item && trading_item_unit_price)
    (trading_item_unit_price * purchase_process_trading_item.item_quantity)
  end
end
