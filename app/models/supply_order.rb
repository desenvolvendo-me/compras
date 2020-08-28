class SupplyOrder < Compras::Model
  include MaterialBalance
  include NumberSupply

  attr_accessible :licitation_process_id, :creditor_id, :authorization_date, :year, :observation, :updatabled,
                  :items_attributes, :invoices_attributes, :supply_requests_attributes, :supply_budgetaries_attributes,
                  :pledge, :purchase_solicitation_id, :contract_id

  has_enumeration_for :order_status, :with => SupplyOrderStatus,
                      :create_helpers => true, :create_scopes => true

  belongs_to :contract
  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor
  belongs_to :purchase_form


  has_many :items, class_name: 'SupplyOrderItem', dependent: :destroy
  has_many :invoices, class_name: 'Invoice', dependent: :destroy
  has_many :supply_requests, class_name: "SupplyOrderRequests", dependent: :destroy
  has_many :supply_budgetaries, class_name: "SupplyOrderBudgetary", :dependent => :restrict,
           :inverse_of => :supply_order, :order => :id

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc { |att| att['quantity'].blank?}
  accepts_nested_attributes_for :invoices, allow_destroy: true,  reject_if: proc { |att| att['number'].blank?}
  accepts_nested_attributes_for :supply_requests, allow_destroy: true
  accepts_nested_attributes_for :supply_budgetaries, allow_destroy: true


  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true

  validates :authorization_date, :contract, :purchase_solicitation, :licitation_process, presence: true
  validates :pledge, presence: true, if: :is_contract_minute?
  # validates :items_quantity_permitted

  orderize "id DESC"
  filterize

  after_create :set_status_defaut
  after_create :set_contract_item_balance
  before_update :change_status_in_service
  before_save :set_creditor



  scope :by_purchasing_unit, lambda {|current_user|
    use_pur_uni = UserPurchasingUnit.where(user_id:current_user).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
    pur_sol = PurchaseSolicitation.where("department_id in (?)",departments).pluck(:id)

    where { purchase_solicitation_id.in pur_sol }
  }

  scope :by_purchase_solicitation, lambda{|q|
    unless q.blank?
     where{ purchase_solicitation_id.eq(q) }
    end
  }

  def set_creditor
    self.contract.nil? ? self.creditor=nil:self.creditor = self.contract.creditor
  end

  def items_quantity_permitted
    message = calc_items_quantity(self.licitation_process, self.purchase_solicitation)
    errors.add(:items, "Quantidade solicitada indisponível. Quantidades disponíveis: #{message}") if message.present?
  end

  def to_s
    "#{number}"
  end

  def open?
    [SupplyOrderStatus::SENT, SupplyOrderStatus::PARTIALLY_ANSWERED, SupplyOrderStatus::PENDING_DELIVERY].include? self.order_status
  end

  private

  def set_status_defaut
    update_column("order_status", SupplyOrderStatus::SENT)
  end

  def is_contract_minute?
    contract.type_contract == ContractMinute::MINUTE
  end

  def change_status_in_service
    if defined? self.supply_request && self.supply_request.any?
      self.updatabled? ? status = SupplyRequestStatus::DELIVERED : status = SupplyRequestStatus::IN_SERVICE
      self.supply_requests.each do |supply_order_request|
        supply_order_request.supply_request.update_attribute(:supply_request_status, status) if supply_order_request.supply_request
      end
    end
  end

  def set_contract_item_balance
    items.each do |item|
      contract_balance = ContractItemBalance.new
      contract_balance.movable = self
      contract_balance.contract_balance = true
      contract_balance.purchase_process_id = licitation_process_id
      contract_balance.contract_id = contract_id
      contract_balance.creditor_id = creditor_id
      contract_balance.purchase_solicitation_id = purchase_solicitation_id
      contract_balance.material_id = item.material_id
      contract_balance.quantity = item.quantity
      contract_balance.save
    end
  end

end