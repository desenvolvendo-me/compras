class Creditor < Compras::Model
  attr_accessible :person_id, :occupation_classification_id
  attr_accessible :main_cnae_id, :municipal_public_administration, :autonomous
  attr_accessible :social_identification_number
  attr_accessible :contract_start_date, :cnae_ids, :documents_attributes
  attr_accessible :representative_person_ids, :representative_ids
  attr_accessible :accounts_attributes, :material_ids, :creditor_balances_attributes
  attr_accessible :regularization_or_administrative_sanctions_attributes

  attr_readonly :person_id

  attr_modal :person_id, :main_cnae_id

  belongs_to :main_cnae, :class_name => 'Cnae'
  belongs_to :occupation_classification
  belongs_to :person

  has_many :accounts, :class_name => 'CreditorBankAccount', :inverse_of => :creditor, :dependent => :destroy
  has_many :agencies, :through => :accounts
  has_many :banks, :through => :accounts, :source => :agency
  has_many :cnaes, :through => :creditor_secondary_cnaes
  has_many :creditor_balances, :inverse_of => :creditor, :dependent => :destroy
  has_many :creditor_materials, :dependent => :destroy
  has_many :creditor_secondary_cnaes, :dependent => :destroy
  has_many :direct_purchases, :dependent => :restrict
  has_many :document_types, :through => :documents
  has_many :documents, :class_name => 'CreditorDocument', :dependent => :destroy, :order => :id
  has_many :licitation_process_bidders, :dependent => :restrict
  has_many :licitation_processes, :through => :licitation_process_bidders, :dependent => :restrict
  has_many :materials, :through => :creditor_materials
  has_many :materials_classes, :through => :materials
  has_many :materials_groups, :through => :materials_classes
  has_many :pledges, :dependent => :restrict
  has_many :precatories, :dependent => :restrict
  has_many :price_collection_proposals, :dependent => :restrict, :order => :id
  has_many :price_collections, :through => :price_collection_proposals
  has_many :registration_cadastral_certificates, :dependent => :destroy
  has_many :regularization_or_administrative_sanctions, :inverse_of => :creditor, :dependent => :destroy
  has_many :representative_people, :through => :representatives, :source => :representative_person
  has_many :representatives, :class_name => 'CreditorRepresentative', :dependent => :destroy, :order => :id
  has_many :reserve_funds, :dependent => :restrict

  has_one :user, :as => :authenticable

  delegate :personable_type, :cnpj, :state_registration, :responsible,
           :identity_document, :company?, :to => :person, :allow_nil => true
  delegate :identity_document, :to => :responsible, :prefix => true, :allow_nil => true
  delegate :phone, :fax, :name, :to => :person, :allow_nil => true
  delegate :address, :city, :zip_code, :to => :person, :allow_nil => true
  delegate :neighborhood, :state, :country, :zip_code, :to => :address, :allow_nil => true
  delegate :email, :to => :person, :allow_nil => true, :prefix => true
  delegate :bank_id, :to => :accounts, :allow_nil => true
  delegate :materials_class, :materials_group, :to => :materials, :allow_nil => true
  delegate :login, :email, :to => :user, :allow_nil => true
  delegate :company_size, :choose_simple, :legal_nature,
           :commercial_registration_number, :commercial_registration_date,
           :to => :person, :allow_nil => true
  delegate :code, :to => :main_cnae, :prefix => true, :allow_nil => true

  accepts_nested_attributes_for :accounts, :allow_destroy => true
  accepts_nested_attributes_for :creditor_balances, :allow_destroy => true
  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :regularization_or_administrative_sanctions, :allow_destroy => true
  accepts_nested_attributes_for :representatives, :allow_destroy => true
  accepts_nested_attributes_for :user

  validates :person, :presence => true
  validates :person_id, :uniqueness => true, :allow_blank => true
  validates :contract_start_date, :timeliness => { :type => :date }, :allow_blank => true
  validates :contract_start_date, :social_identification_number, :presence => true, :if => :autonomous?
  validates :main_cnae, :presence => true, :if => :company?
  validate :uniqueness_of_document_type
  validate :person_in_representatives
  validate :secondary_cnae_in_main_cnae

  before_save :clean_fields_when_is_no_autonomous

  orderize :id
  filterize

  def to_s
    person.to_s
  end

  def selected_cnaes
    cnae_ids | [ main_cnae_id ]
  end

  def user?
    user.present? && user.persisted?
  end

  protected

  def clean_fields_when_is_no_autonomous
    return if autonomous?

    self.contract_start_date = nil
    self.social_identification_number = nil
  end

  def uniqueness_of_document_type
    single_documents = []

    documents.each do |document|
      if single_documents.include? document.document_type_id
        errors.add(:documents, :invalid)

        document.errors.add(:document_type_id, :taken)
      end
      single_documents << document.document_type_id
    end
  end

  def person_in_representatives
    return unless person && representatives

    if representative_person_ids.include? person.id
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
