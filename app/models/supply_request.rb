class SupplyRequest < Compras::Model
  include MaterialBalance
  include NumberSupply

  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
                  :items_attributes, :year, :purchase_solicitation_id,
                  :updatabled, :contract_id, :supply_request_status,
                  :justification, :supply_request_file,:user_id,
                  :department_id, :number

  attr_modal :number, :creditor_id,:authorization_date, :licitation_process_id, :user, :purchase_solicitation_id

  mount_uploader :supply_request_file, UnicoUploader

  belongs_to :department
  belongs_to :contract
  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor
  belongs_to :user

  has_many :items, class_name: 'SupplyRequestItem', dependent: :destroy
  has_many :supply_orders, class_name: "SupplyOrderRequests"
  has_many :supply_request_attendances, :dependent => :destroy, :order => :sequence, :inverse_of => :supply_request

  accepts_nested_attributes_for :items, allow_destroy: true

  has_enumeration_for :supply_request_status, :with => SupplyRequestStatus, :create_helpers => true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true

  validates :authorization_date, :contract, :purchase_solicitation, :licitation_process, presence: true
  validate :items_quantity_permitted
  validate :at_least_one_item

  orderize "id DESC"
  filterize

  scope :by_creditor, lambda {|creditor|
    where { creditor_id.in creditor }
  }

  scope :by_purchase_solicitation, lambda {|purchase_solicitation|
    where { purchase_solicitation_id.in purchase_solicitation }
  }

  def to_s
    "#{contract} - #{licitation_process}"
  end

  before_create :set_status_sent
  before_save :set_creditor

  def get_value
    value = 0
    realignment_price = RealignmentPrice.select(:id).find_by_purchase_process_id(self.licitation_process_id)
    self.items.each do |item|
      licitation_process_item = RealignmentPriceItem.joins(:material).where(realignment_price_id:realignment_price.id,material:{id:item.material_id})
      if licitation_process_item.size != 0
        value += licitation_process_item[0].price * item.quantity
      end
    end
    value
  end

  def set_creditor
    self.contract.nil? ? self.creditor = nil:self.creditor = self.contract.creditor
  end

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

  def at_least_one_item
    errors.add(:items, :at_least_one_item) if items.empty?
  end
end
