class SupplyRequest < Compras::Model
  include MaterialBalance
  include NumberSupply

  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
                  :items_attributes, :year, :purchase_solicitation_id,
                  :updatabled, :contract_id, :supply_request_status, :order_name,
                  :justification, :supply_request_file,:user_id, :signature_responsible_id,
                  :department_id, :number_year, :secretary_signature, :signature_secretary_id

  attr_modal :number, :creditor_id, :authorization_date, :department_id,  :secretary_id, :purchase_department_id
  attr_accessor :secretary_id, :purchase_department_id

  mount_uploader :supply_request_file, UnicoUploader

  belongs_to :department
  belongs_to :contract
  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor
  belongs_to :user
  belongs_to :signature_secretary, class_name: 'Secretary'
  belongs_to :signature_responsible, class_name: 'Employee'

  has_one :secretary, class_name: 'Secretary', through: :department

  has_many :items, class_name: 'SupplyRequestItem', dependent: :destroy
  has_many :supply_orders, class_name: "SupplyOrderRequests"
  has_many :supply_request_attendances, :dependent => :destroy, :order => :sequence, :inverse_of => :supply_request

  accepts_nested_attributes_for :items, allow_destroy: true

  has_enumeration_for :supply_request_status, :with => SupplyRequestStatus, :create_helpers => true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true



  validates :authorization_date, :contract, :purchase_solicitation, :licitation_process, :department, presence: true
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

  scope :to_secretary_approv, lambda{|secretary_employ|
    joins{ "LEFT JOIN (SELECT RANK() OVER (PARTITION BY supply_request_id ORDER BY updated_at DESC) r, *
                FROM compras_supply_request_attendances
                group by compras_supply_request_attendances.supply_request_id, compras_supply_request_attendances.id)
                as compras_supply_request_attendances on compras_supply_request_attendances.supply_request_id = compras_supply_requests.id" }
        .joins { purchase_solicitation.department.secretary.secretary_settings }
        .where { compras_supply_request_attendances.service_status.eq(SupplyRequestServiceStatus::ORDER_IN_ANALYSIS) }
        .where { compras_supply_request_attendances.r.eq(1) }
        .where { compras_secretary_settings.employee_id.eq(secretary_employ) }.order{ number }
        .group { compras_supply_request_attendances.service_status }
        .group{ compras_supply_requests.number }
        .group { compras_supply_requests.id }
  }

  scope :by_contract, lambda{|contract|
    unless contract.blank?
      where(contract_id: contract)
    end
  }

  scope :by_material, lambda{|material|
    unless material.blank?
      joins(:items).where(compras_supply_request_items:{material_id: material})
    end
  }

  scope :by_secretary, lambda{|secretary|
    unless secretary.blank?
     joins(:department).where(compras_departments:{secretary_id: secretary})
    end
  }

  scope :by_ids, lambda{|ids| where{ id.in(ids.split(',')) } }

  scope :filter_by_user, lambda{|current_user|
      id  = current_user.id
      use_pur_uni = current_user.user_purchasing_units.pluck(:purchasing_unit_id)
      departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
      pur_sol_ids = PurchaseSolicitation.where("department_id in (?)",departments).pluck(:id)

      where("purchase_solicitation_id in (?) or user_id = ? ",
      pur_sol_ids,current_user.id )  
  }

  def to_s
    "#{contract} - #{licitation_process}"
  end

  before_create :set_status_sent
  before_save :set_creditor
  # after_create :set_contract_item_balance

  def get_value
    value = 0
    self.items.each do |item|
      value += item.get_unit_price.to_f * item.quantity.to_f
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
        message = message.present? ? message.concat(", ").concat(response["message"].to_s) : response["message"].to_s
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

  # def set_contract_item_balance
  #   contract_balance = ContractItemBalance.newpurchase
  #   contract_balance.movable = self
  #   contract_balance.contract_balance = true
  #   contract_balance.quantity_type = QuantityType::NEGATIVE_AMOUNT
  #   contract_balance.save
  # end

  def self.filter(params)
    query = scoped
    query = query.where{ number.eq(params[:number]) } if params[:number].present?
    query = query.where{ year.eq(params[:year]) } if params[:year].present?
    query = query.where{ creditor_id.eq(params[:creditor_id]) } if params[:creditor_id].present?
    query = query.where{ authorization_date.eq(params[:authorization_date]) } if params[:authorization_date].present?
    query = query.where{ department_id.eq(params[:department_id]) } if params[:department_id].present?
    query = query.joins{ purchase_solicitation }.where{purchase_solicitation.department_id.eq(params[:purchase_department_id]) } if params[:purchase_department_id].present?
    query = query.joins{ secretary }.where{ secretary.id.eq(params[:secretary_id]) } if params[:secretary_id].present?

    query
  end
end
