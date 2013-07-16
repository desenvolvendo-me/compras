class Creditor < Compras::Model
  include CustomData
  reload_custom_data

  attr_accessible :person_id, :contract_start_date,
                  :occupation_classification_id, :main_cnae_id, :cnae_ids,
                  :municipal_public_administration, :autonomous,
                  :social_identification_number, :documents_attributes,
                  :representative_person_ids, :creditor_balances_attributes,
                  :accounts_attributes, :material_ids, :representative_ids,
                  :regularization_or_administrative_sanctions_attributes,
                  :organ_responsible_for_registration

  attr_accessor :name, :cpf, :cnpj

  attr_modal :name, :cpf, :cnpj

  has_enumeration_for :organ_responsible_for_registration, with: OrganResponsible

  belongs_to :main_cnae, :class_name => 'Cnae'
  belongs_to :occupation_classification
  belongs_to :person

  has_many :accounts, :class_name => 'CreditorBankAccount', :inverse_of => :creditor, :dependent => :destroy
  has_many :agencies, :through => :accounts
  has_many :banks, :through => :accounts, :source => :agency
  has_many :cnaes, :through => :creditor_secondary_cnaes
  has_many :creditor_balances, :inverse_of => :creditor, :dependent => :destroy
  has_many :creditor_materials, :dependent => :destroy, :inverse_of => :creditor
  has_many :creditor_secondary_cnaes, :dependent => :destroy
  has_many :document_types, :through => :documents
  has_many :documents, :class_name => 'CreditorDocument', :dependent => :destroy, :order => :id
  has_many :bidders, :dependent => :restrict
  has_many :licitation_processes, :through => :bidders, :dependent => :restrict
  has_many :materials, :through => :creditor_materials, :order => :id
  has_many :material_classes, :through => :materials
  has_many :precatories, :dependent => :restrict
  has_many :price_collection_proposals, :dependent => :restrict, :order => :id
  has_many :price_collections, :through => :price_collection_proposals
  has_many :registration_cadastral_certificates, :dependent => :destroy
  has_many :regularization_or_administrative_sanctions, :inverse_of => :creditor, :dependent => :destroy
  has_many :representative_people, :through => :representatives, :source => :representative_person
  has_many :representatives, :class_name => 'CreditorRepresentative', :dependent => :destroy, :order => :id
  has_many :purchase_process_accreditation_creditors, :dependent => :restrict
  has_many :purchase_process_items, :dependent => :restrict
  has_many :purchase_process_creditor_proposals, dependent: :restrict
  has_many :realignment_prices, dependent: :restrict
  has_many :proposal_disqualifications, class_name: 'PurchaseProcessCreditorDisqualification', dependent: :restrict
  has_many :licitation_process_ratifications, dependent: :restrict
  has_many :licitation_process_ratification_items, through: :licitation_process_ratifications

  has_one :user, :as => :authenticable

  has_and_belongs_to_many :contracts, join_table: :compras_contracts_creditors

  delegate :personable_type, :cnpj, :state_registration, :responsible,
           :identity_document, :company?, :phone, :fax, :benefited, :address,
           :city, :zip_code, :company_size, :choose_simple, :legal_nature,
           :commercial_registration_number, :commercial_registration_date,
           :personable_type_humanize, :company_partners, :uf_state_registration,
           :individual?,
           :to => :person, :allow_nil => true
  delegate :email, :to => :person, :allow_nil => true, :prefix => true
  delegate :identity_document, :to => :responsible, :prefix => true, :allow_nil => true
  delegate :name, :to => :person, :allow_nil => true
  delegate :neighborhood, :state, :country, :zip_code, :to => :address, :allow_nil => true
  delegate :bank_id, :to => :accounts, :allow_nil => true
  delegate :materials_class, :to => :materials, :allow_nil => true
  delegate :login, :email, :to => :user, :allow_nil => true
  delegate :code, :to => :main_cnae, :prefix => true, :allow_nil => true

  accepts_nested_attributes_for :accounts, :allow_destroy => true
  accepts_nested_attributes_for :creditor_balances, :allow_destroy => true
  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :regularization_or_administrative_sanctions, :allow_destroy => true
  accepts_nested_attributes_for :representatives, :allow_destroy => true
  accepts_nested_attributes_for :user

  validates :person, :presence => true
  validates :contract_start_date, :timeliness => { :type => :date }, :allow_blank => true
  validates :contract_start_date, :social_identification_number, :presence => true, :if => :autonomous?
  validates :main_cnae, :presence => true, :if => :company?
  validates :documents, :no_duplication => :document_type_id
  validate :person_in_representatives
  validate :secondary_cnae_in_main_cnae
  validate :validate_custom_data

  before_save :clean_fields_when_is_no_autonomous

  orderize :name, on: :person
  filterize

  scope :term, lambda { |q|
    joins { person }.
    where { person.name.like("#{q}%") }
  }

  scope :by_id, lambda { |id|
    where { |creditor| creditor.id.eq(id) }
  }

  scope :accreditation_purchase_process_id, ->(purchase_process_id) do
    joins { purchase_process_accreditation_creditors.purchase_process_accreditation }.
    where {
      purchase_process_accreditation_creditors.purchase_process_accreditation.licitation_process_id.eq(purchase_process_id)
    }
  end

  scope :enabled_by_licitation, lambda { | licitation_process_id |
    joins { bidders }.
    where { (bidders.licitation_process_id.eq licitation_process_id) & (bidders.enabled.eq 't') }
  }

  scope :winner_without_disqualifications, -> {
    joins { purchase_process_creditor_proposals }.
    where {
      (purchase_process_creditor_proposals.ranking.eq 1) &
      (purchase_process_creditor_proposals.disqualified.not_eq 't')
    }.uniq
  }

  scope :enabled_or_benefited_by_purchase_process_id, -> purchase_process_id  do
    joins { bidders.creditor.person.personable(Company).outer.company_size.outer.extended_company_size.outer }.
    where {
      (bidders.enabled.eq('t') | compras_extended_company_sizes.benefited.eq(true)) &
      bidders.licitation_process_id.eq(purchase_process_id)
    }.uniq
  end

  scope :without_direct_purchase_ratification, lambda { |licitation_process_id|
    creditor_ids = LicitationProcess.find(licitation_process_id).licitation_process_ratification_creditor_ids

    scoped.select { 'compras_creditors.*, unico_people.name' }.
    joins { purchase_process_items.licitation_process.licitation_process_ratifications.outer }.
    joins { person }.
    where {
      purchase_process_items.licitation_process_id.eq(licitation_process_id) &
      purchase_process_items.creditor_id.not_in(creditor_ids)
    }.uniq
  }

  scope :by_ratification_and_licitation_process_id, ->(licitation_process_id) do
    joins { licitation_process_ratifications }.
    where { |query| query.licitation_process_ratifications.licitation_process_id.eq(licitation_process_id) }
  end

  scope :without_licitation_ratification, lambda { |licitation_process_id|
    creditor_ids = LicitationProcess.find(licitation_process_id).licitation_process_ratification_creditor_ids

    scoped.select { 'compras_creditors.*, unico_people.name' }.
    joins { bidders.licitation_process.licitation_process_ratifications.outer }.
    joins { person }.
    where {
      bidders.licitation_process_id.eq(licitation_process_id) &
      bidders.creditor_id.not_in(creditor_ids)
    }.uniq
  }

  scope :won_calculation, lambda { |licitation_process_id|
    joins { bidders.licitation_process.creditor_proposals }.
    where { |query|
      query.bidders.licitation_process.creditor_proposals.licitation_process_id.eq(licitation_process_id) &
      query.bidders.licitation_process.creditor_proposals.ranking.eq(1)
    }.
    where { '"compras_creditors".id = "compras_purchase_process_creditor_proposals".creditor_id' }.
    uniq
  }

  scope :won_calculation_for_trading, lambda{ |licitation_process_id|
    creditor_ids = LicitationProcess.find(licitation_process_id).trading_items.map { |item|
      TradingItemWinner.new(item).creditor.id
    }

    scoped.where("compras_creditors.id in (?)", creditor_ids)
  }

  scope :winners, ->(purchase_process) do
    query = scoped.enabled_by_licitation(purchase_process.id)

    if purchase_process.licitation?
      if purchase_process.trading?
        query = scoped.
          accreditation_purchase_process_id(purchase_process.id).
          won_calculation_for_trading(purchase_process.id)
      else
        query = query.won_calculation(purchase_process.id)
      end
    end

    query.order(:id)
  end

  def self.filter(params)
    query = scoped
    query = query.joins { person.outer.personable(Company).outer }
    query = query.joins { person.outer.personable(Individual).outer }
    query = query.where { person.name.matches("#{params[:name]}%") } if params[:name].present?
    query = query.where { person.personable(Individual).cpf.eq(params[:cpf]) } if params[:cpf].present?
    query = query.where { person.personable(Company).cnpj.eq(params[:cnpj]) } if params[:cnpj].present?
    query
  end

  def to_s
    person.to_s
  end

  def selected_cnaes
    cnae_ids | [ main_cnae_id ]
  end

  def user?
    user.present? && user.persisted?
  end

  def proposal_by_item(purchase_process_id, item)
    purchase_process_creditor_proposals.
      by_item_id(item.id).
      licitation_process_id(purchase_process_id).
      first
  end

  def proposal_by_lot(purchase_process_id, lot)
    purchase_process_creditor_proposals.
      licitation_process_id(purchase_process_id).
      by_lot(lot).
      first
  end

  def first_representative_individual
    representative_people.joins { personable(Individual) }.first
  end

  protected

  def clean_fields_when_is_no_autonomous
    return if autonomous?

    self.contract_start_date = nil
    self.social_identification_number = nil
  end

  def person_in_representatives
    return unless person && representatives

    if person && representative_person_ids.include?(person.id)
      errors.add(:representatives, :cannot_have_representative_equal_creditor)
    end
  end

  def secondary_cnae_in_main_cnae
    return unless main_cnae && cnaes

    if cnae_ids.include? main_cnae.id
      errors.add(:cnaes, :cannot_have_secondary_cnae_equal_main_cnae)
    end
  end
end
