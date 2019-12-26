class SupplyRequest < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
                  :items_attributes, :year, :purchase_solicitation_id,
                  :updatabled, :contract_id, :supply_request_status

  attr_modal :licitation_process_id, :creditor_id, :year, :authorization_date

  belongs_to :contract
  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor

  has_many :items, class_name: 'SupplyRequestItem', dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true

  has_enumeration_for :supply_request_status, :with => SupplyRequestStatus, :create_helpers => true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true

  validates :authorization_date, :contract, :purchase_solicitation, :licitation_process, presence: true
  validate :items_quantity_permitted

  orderize "id DESC"
  filterize

  def to_s
    "#{contract} - #{licitation_process}"
  end

  before_create :set_status_sent

  def items_quantity_permitted
    message = calc_items_quantity(self.licitation_process, self.purchase_solicitation)
    errors.add(:items, "Quantidade solicitada indisponível. Quantidades disponíveis: #{message}") if message.present?
  end

  def calc_items_quantity(licitation_process, purchase_solicitation)
    message = ""
    unless licitation_process.nil?
      self.items.each do |item|
        response = SupplyRequest.total_balance(licitation_process, purchase_solicitation, item.material, item.quantity, self)
        message = message.present? ? message.concat(", ").concat(response["message"]) : response["message"]
      end
    end
    message
  end

  def self.total_balance(licitation_process, purchase_solicitation, material, quantity, supply_request = nil)
    response = {}

    quantity_autorized = quantity_autorized(licitation_process, purchase_solicitation, material)

    supply_requests = SupplyRequest.where(licitation_process_id: licitation_process.id)
    supply_requests = supply_requests.where("compras_supply_requests.id != #{supply_request.id}") if supply_request.try(:id)
    quantity_delivered = supply_requests.joins(:items).where("compras_supply_request_items.material_id = ?", material.id).sum(:quantity).to_f

    if (quantity_autorized - (quantity_delivered + quantity.to_i)) < 0
      response["message"] = ("#{material.description} (#{quantity_autorized - quantity_delivered})")
    end

    response["total"] = quantity_autorized
    response["balance"] = quantity_autorized - quantity_delivered
    response
  end

  private

  def self.quantity_autorized(licitation_process, purchase_solicitation, material)
    licitation_process = LicitationProcess.find(licitation_process.id)
    quantity_licitation_process = licitation_process.items.where(material_id: material.id).sum(:quantity)
    quantity_purchase_solicitation = licitation_process.purchase_solicitations.where(purchase_solicitation_id: purchase_solicitation.id).first.purchase_solicitation.items.where(material_id: material.id).sum(:quantity).to_i

    return quantity_purchase_solicitation
  end

  def set_status_sent
    supply_request_status = SupplyRequestStatus::SENT
  end
end
