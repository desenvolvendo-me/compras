class Creditor < ActiveRecord::Base
  attr_accessible :person_id, :occupation_classification_id, :company_size_id
  attr_accessible :main_cnae_id, :municipal_public_administration, :autonomous
  attr_accessible :social_identification_number, :choose_simple
  attr_accessible :contract_start_date, :cnae_ids, :documents_attributes
  attr_accessible :representative_person_ids, :representative_ids

  belongs_to :person
  belongs_to :occupation_classification
  belongs_to :company_size
  belongs_to :main_cnae, :class_name => 'Cnae'
  has_many :creditor_secondary_cnaes, :dependent => :destroy
  has_many :cnaes, :through => :creditor_secondary_cnaes
  has_many :documents, :class_name => 'CreditorDocument', :dependent => :destroy, :order => :id
  has_many :document_types, :through => :documents
  has_many :representatives, :class_name => 'CreditorRepresentative', :dependent => :destroy, :order => :id
  has_many :representative_people, :through => :representatives, :source => :representative_person

  delegate :personable_type, :company?, :to => :person, :allow_nil => true

  accepts_nested_attributes_for :documents, :allow_destroy => true
  accepts_nested_attributes_for :representatives, :allow_destroy => true

  validates :person, :presence => true
  validates :contract_start_date,
    :presence => { :if => :autonomous? },
    :timeliness => { :type => :date }, :allow_blank => true
  validates :company_size, :main_cnae, :presence => true, :if => :company?
  validate :uniqueness_of_document_type
  validate :person_in_representatives

  orderize :id
  filterize

  def to_s
    person.to_s
  end

  def selected_cnaes
    cnae_ids | [ main_cnae_id ]
  end

  protected

  def uniqueness_of_document_type
    countable = Hash.new

    documents.each do |document|
      if document.document_type_id.blank?
        document.errors.add(:document_type_id, :blank)
      else
        countable[document.document_type_id] ||= 0
        countable[document.document_type_id] = countable[document.document_type_id].to_i + 1
      end
    end

    documents.each do |document|
      if countable[document.document_type_id].to_i > 1
        # FIXME: rails issue, see: https://github.com/rails/rails/issues/5061
        errors.add(:documents, :invalid)

        document.errors.add(:document_type_id, :taken)
      end
    end
  end

  def person_in_representatives
    representatives.each do |representative|
      if representative.representative_person == person
          errors.add(:representatives, :cannot_have_representative_equal_creditor)
      end
    end
  end
end
