class Contract < Compras::Model
  include HelperModule
  include BelongsToResource

  attr_accessible :year, :contract_number, :sequential_number, :publication_date,
                  :lawyer_code, :contract_file, :signature_date, :end_date,
                  :description, :content, :contract_value, :creditor_id, :type_contract,
                  :guarantee_value, :contract_validity, :subcontracting, :management_object_id,
                  :cancellation_date, :cancellation_reason, :delivery_schedules_attributes,
                  :dissemination_source_id, :contract_type_id, :contract_additives_attributes,
                  :licitation_process_id, :start_date, :budget_structure_responsible_id,
                  :lawyer_name, :parent_id, :additives_attributes, :penalty_fine, :contract_validations_attributes,
                  :default_fine, :execution_type, :contract_guarantees, :occurrence_contractual_historics_attributes,
                  :consortium_agreement, :department_id, :balance_control_type, :authorized_areas_attributes,
                  :purchasing_unit_id, :financials_attributes, :balance, :contract_termination_attributes,
                  :consumption_minutes_attributes, :principal_contract, :linked_contracts_attributes

  attr_modal :year, :contract_number, :sequential_number,
             :signature_date, :creditor

  acts_as_nested_set
  mount_uploader :contract_file, UnicoUploader

  has_enumeration_for :contract_guarantees, :with => UnicoAPI::Resources::Compras::Enumerations::ContractGuarantees
  has_enumeration_for :type_contract, :with => ContractMinute
  has_enumeration_for :execution_type, :create_helpers => true
  has_enumeration_for :balance_control_type,
                      :with => ContractBalanceControlType, :create_helpers => true

  belongs_to :department
  belongs_to :purchasing_unit
  belongs_to :budget_structure_responsible, :class_name => "Employee"
  belongs_to :contract_type
  belongs_to :dissemination_source
  belongs_to :licitation_process
  belongs_to :creditor
  belongs_to :management_object
  belongs_to :parent, class_name: 'Contract'

  belongs_to_resource :budget_structure

  has_many :additives, class_name: "ContractAdditive", dependent: :restrict
  has_many :delivery_schedules, :dependent => :destroy, :order => :sequence
  has_many :occurrence_contractual_historics, :dependent => :restrict
  has_many :ratifications, through: :licitation_process, source: :licitation_process_ratifications
  has_many :ratifications_items, through: :ratifications, source: :licitation_process_ratification_items
  has_many :supply_orders
  has_many :authorized_areas, :class_name => "ContractDepartment", :dependent => :restrict,
                              :inverse_of => :contract, :order => :id
  has_many :contract_validations, :dependent => :destroy, :inverse_of => :contract
  has_many :supply_requests
  has_many :financials, :class_name => "ContractFinancial", :dependent => :restrict,
                        :inverse_of => :contract, :order => :id
  has_many :creditors, class_name: "ContractsUnicoCreditor"
  has_many :contract_additives
  has_many :consumption_minutes, :class_name => "ContractConsumptionMinute"
  has_many :linked_contracts

  has_one :contract_termination, :dependent => :restrict

  accepts_nested_attributes_for :additives, :allow_destroy => true
  accepts_nested_attributes_for :delivery_schedules, :allow_destroy => true
  accepts_nested_attributes_for :authorized_areas, allow_destroy: true
  accepts_nested_attributes_for :financials, allow_destroy: true
  accepts_nested_attributes_for :contract_additives, allow_destroy: true
  accepts_nested_attributes_for :occurrence_contractual_historics, allow_destroy: true
  accepts_nested_attributes_for :contract_validations, allow_destroy: true
  accepts_nested_attributes_for :contract_termination, allow_destroy: true
  accepts_nested_attributes_for :consumption_minutes, allow_destroy: true
  accepts_nested_attributes_for :linked_contracts, allow_destroy: true

  delegate :execution_type_humanize, :contract_guarantees_humanize, :contract_guarantees,
           :to => :licitation_process, :allow_nil => true
  delegate :budget_allocations_ids, :modality_humanize, :process, :year, :type_of_removal_humanize,
           :to => :licitation_process, :allow_nil => true, :prefix => true

  validates :year, :mask => "9999", :allow_blank => true
  validates :year, :contract_number, :publication_date, :creditor,
            :dissemination_source, :content, :contract_type,
            :contract_value, :contract_validity, :signature_date, :start_date,
            :end_date, :budget_structure_responsible, :licitation_process_id,
            :default_fine, :penalty_fine, :type_contract, :presence => true
  validates :end_date, :timeliness => {
                         :after => :signature_date,
                         :type => :date,
                         :after_message => :end_date_should_be_after_signature_date,
                       }, :allow_blank => true
  validate :principal_contract_per_creditor, if: :principal_contract?

  filterize

  scope :founded, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::FOUNDED) }
  
  scope :by_years, lambda {
    current_year = Date.current.year
    last_year = current_year - 1

    where(year:[last_year,current_year])
  }

  scope :management, joins { contract_type }.where { contract_type.service_goal.eq(ServiceGoal::CONTRACT_MANAGEMENT) }
  scope :by_signature_date, lambda { |date_range|
    where { signature_date.in(date_range) }
  }

  scope :by_days_finish, lambda { |days = 30|
    where { end_date.gteq(Date.today) & end_date.lteq(Date.today + days.to_i) }
  }

  scope :between_days_finish, lambda { |start_at, end_at|
    where { end_date.gteq(Date.today + start_at.to_i) & end_date.lteq(Date.today + end_at.to_i) }
  }

  scope :by_signature_period, lambda { |started_at, ended_at|
    where { signature_date.gteq(started_at) & signature_date.lteq(ended_at) }
  }
  # TODO ver porque tá chamdno o scope msm vazio
  scope :purchase_process_id, -> (purchase_process_id) do
          if purchase_process_id != ""
            where { |query| query.licitation_process_id.eq(purchase_process_id) }
          end
        end

  scope :except_type_of_removal, -> (type_of_removal) do
          joins { licitation_process }.
            where {
            licitation_process.type_of_removal.not_eq(type_of_removal) |
              licitation_process.type_of_removal.eq(nil)
          }
  end

  scope :by_creditor_principal_contracts, lambda{|creditor_id|
    where(creditor_id: creditor_id, principal_contract: true)
  }

  scope :by_licitation_process, lambda{|licitation_id|
    where(licitation_process_id: licitation_id)
  }
  
  scope :by_status, lambda{|type|
    if type == "finished"
      where("'#{Date.today}' > end_date")
    else
      where("'#{Date.today}' <= end_date")
    end
  }

  orderize "id DESC"

  def winning_items
    licitation_process_id = self.try(:licitation_process).try(:id)
    creditor_id = self.creditor_id
    LicitationProcessRatificationItem.
      joins { licitation_process_ratification.licitation_process }.
      where { licitation_process_ratification.licitation_process.id.eq(licitation_process_id) }.
      where { licitation_process_ratification.creditor_id.in(creditor_id) }
  end

  def to_s
    "#{contract_number} - #{creditor}"
  end

  def status
    end_date && Date.today > end_date ? 'Finalizado' : 'Vigente'
  end

  def modality_humanize
    if licitation_process.try(:simplified_processes?)
      licitation_process_type_of_removal_humanize
    else
      licitation_process_modality_humanize
    end
  end

  def self.next_sequential(year)
    self.where { self.year.eq year }.size + 1
  end

  def pledges
    Pledge.all(params: { by_contract_id: id })
  end

  def solicitations
    licitation_process_id = self.try(:licitation_process).try(:id)
    creditor_id = self.creditor_id

    material_ids = Material.by_ratification(licitation_process_id, creditor_id).pluck(:id).uniq

    purchase_solicitation_ids = PurchaseSolicitation.with_materials_per_licitation(licitation_process_id, material_ids).pluck(:id).uniq

    group_purchase_solicitation_with_materials(material_ids, purchase_solicitation_ids)
  end

  def self.count_contracts_finishing
    { 'between_121_150': Contract.between_days_finish(121, 150).count + LinkedContract.where(end_date_contract:Date.today+121..Date.today+150).count + ContractAdditive.between_days_finish('121','150').count,
     'between_91_120': Contract.between_days_finish(91, 120).count + LinkedContract.where(end_date_contract:Date.today+91..Date.today+120).count + ContractAdditive.between_days_finish('91','120').count,
     'between_61_90': Contract.between_days_finish(61, 90).count + LinkedContract.where(end_date_contract:Date.today+61..Date.today+90).count + ContractAdditive.between_days_finish('61','90').count,
     'between_31_60': Contract.between_days_finish(31, 60).count  + LinkedContract.where(end_date_contract:Date.today+31..Date.today+60).count + ContractAdditive.between_days_finish('31','60').count,
     'until_30': Contract.between_days_finish(0,30).count  + LinkedContract.where(end_date_contract:Date.today..Date.today+30).count + ContractAdditive.between_days_finish('0','30').count }
  end

  def founded_debt_pledges
    Pledge.all(params: { by_founded_debt_contract_id: id })
  end

  def all_pledges
    (pledges + founded_debt_pledges).uniq
  end

  def all_pledges_total_value
    all_pledges.sum(&:amount)
  end

  def allow_termination?
    # contract_termination.blank?
  end

  def per_service_status
    suplly_request_pending = {}
    self.supply_requests.each do |supply_request|
      unless supply_request.supply_request_attendances.last.nil?
        suplly_request_pending[supply_request.supply_request_attendances.last.service_status] = [] unless suplly_request_pending.key? supply_request.supply_request_attendances.last.service_status
        suplly_request_pending[supply_request.supply_request_attendances.last.service_status].push(supply_request.id)
      end
    end
    suplly_request_pending
  end

  def answered
    status = per_service_status
    return [] if status.empty?
    status["fully_serviced"].to_a + status["partially_answered"].to_a
  end

  def pending
    service_status_all = []
    per_service_status.each do |service_status|
      service_status_all += service_status.last
    end
    service_status_all - answered
  end

  private

  def group_purchase_solicitation_with_materials(material_ids, purchase_solicitation_ids)
    solicitation = {}
    purchase_solicitation_ids.each do |solic|
      hash = { solic => [] }
      material_ids.each do |material|
        if PurchaseSolicitation.find(solic).items.pluck(:material_id).include? material
          hash[solic].push(material)
        end
      end
      solicitation.merge! hash
    end
    solicitation
  end

  def principal_contract_per_creditor
    contracts = Contract.by_licitation_process(licitation_process_id).by_creditor_principal_contracts(creditor_id).last
    errors.add(:principal_contract, :already_exist_principal_contract_for_creditor) if contracts != self
  end
end
