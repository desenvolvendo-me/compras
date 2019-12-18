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

  # validates :authorization_date, :creditor, :licitation_process, presence: true
  validate :items_quantity_permitted

  orderize "id DESC"
  filterize

  def items_quantity_permitted
    response = calc_items_quantity(self.licitation_process)
    errors.add(:items, "Quantidade solicitada indisponível. Quantidades disponíveis: #{response["message"]}") if response["message"].present?
  end

  def calc_items_quantity(licitation_process)
    response = {}
    unless licitation_process.nil?
      self.items.each do |item|
        quantity_autorized = LicitationProcess.find(licitation_process.id).items.where(material_id: item.material_id)
        quantity_autorized = quantity_autorized.empty? ? 0 : quantity_autorized[0].quantity
        supply_orders = SupplyOrder.where(licitation_process_id: licitation_process.id)

        quantity_delivered = supply_orders.joins(:items).sum(:quantity).to_f

        if quantity_autorized - (quantity_delivered + item.quantity) < 0
          message = ("#{item.material.description} (#{quantity_autorized - quantity_delivered})")
          response["message"] = response["message"].present? ? response["message"].concat(", ").concat(message) : message
        end
        response["total"] = quantity_autorized
        response["balance"] = quantity_autorized - quantity_delivered
      end
    end
    response
  end

  def pledge
    @pledge ||= Pledge.find(pledge_id) if pledge_id
  end
end