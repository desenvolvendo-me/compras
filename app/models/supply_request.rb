class SupplyRequest < Compras::Model
  include MaterialBalance
  include NumberSupply

  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
                  :items_attributes, :year, :purchase_solicitation_id,
                  :updatabled, :contract_id, :supply_request_status, :justification, :supply_request_file

  attr_modal :licitation_process_id, :creditor_id, :year, :authorization_date

  mount_uploader :supply_request_file, UnicoUploader

  belongs_to :contract
  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor

  has_many :items, class_name: 'SupplyRequestItem', dependent: :destroy
  has_many :supply_orders
  has_many :supply_request_deferrings, :dependent => :destroy, :order => :sequence, :inverse_of => :supply_request

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
        response = SupplyRequest.total_balance(licitation_process, purchase_solicitation, item.material, item.quantity, self, self.contract)
        message = message.present? ? message.concat(", ").concat(response["message"]) : response["message"]
      end
    end
    message
  end


  private

  def set_status_sent
    self.supply_request_status = SupplyRequestStatus::SENT
  end
end
