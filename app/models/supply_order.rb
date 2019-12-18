class SupplyOrder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
                  :items_attributes, :year, :pledge_id, :purchase_solicitation_id, :updatabled

  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor

  has_many :items, class_name: 'SupplyOrderItem', dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true

  validates :authorization_date, :creditor, :purchase_solicitation, :licitation_process, presence: true
  validate :items_quantity_permitted

  orderize "id DESC"
  filterize

  def items_quantity_permitted
    message = calc_items_quantity(self.licitation_process)
    errors.add(:items, "Quantidade solicitada indisponível. Quantidades disponíveis: #{message}") if message.present?
  end

  def calc_items_quantity(licitation_process)
    message = nil
    unless licitation_process.nil?
      self.items.each do |item|
        response = SupplyOrder.total_balance(licitation_process, item.material, item.quantity, self)
        message = message.present? ? message.concat(", ").concat(response["message"]) : response["message"]
      end
    end
    message
  end

  def self.total_balance(licitation_process, material, quantity, supply_order = nil)
    response = {}
    quantity_autorized = LicitationProcess.find(licitation_process.id).items.where(material_id: material.id)
    quantity_autorized = quantity_autorized.empty? ? 0 : quantity_autorized[0].quantity
    supply_orders = SupplyOrder.where(licitation_process_id: licitation_process.id)
    supply_orders = supply_orders.where("compras_supply_orders.id != #{supply_order.id}") if supply_order.try(:id)
    quantity_delivered = supply_orders.joins(:items).sum(:quantity).to_f

    if quantity_autorized - (quantity_delivered + quantity.to_i) < 0
      response["message"] = ("#{material.description} (#{quantity_autorized - quantity_delivered})")
    end

    response["total"] = quantity_autorized
    response["balance"] = quantity_autorized - quantity_delivered
    response
  end

  def pledge
    @pledge ||= Pledge.find(pledge_id) if pledge_id
  end
end