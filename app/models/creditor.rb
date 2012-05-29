class Creditor < ActiveRecord::Base
  attr_accessible :person_id, :occupation_classification_id, :company_size_id
  attr_accessible :main_cnae_id, :municipal_public_administration, :autonomous
  attr_accessible :social_identification_number, :choose_simple
  attr_accessible :contract_start_date, :cnae_ids

  belongs_to :person
  belongs_to :occupation_classification
  belongs_to :company_size
  belongs_to :main_cnae, :class_name => 'Cnae'
  has_many :creditor_secondary_cnaes, :dependent => :destroy
  has_many :cnaes, :through => :creditor_secondary_cnaes

  delegate :personable_type, :company?, :to => :person, :allow_nil => true

  validates :person, :presence => true
  validates :contract_start_date,
    :presence => { :if => :autonomous? },
    :timeliness => { :type => :date }, :allow_blank => true
  validates :company_size, :main_cnae, :presence => true, :if => :company?

  orderize :id
  filterize

  def to_s
    person.to_s
  end

  def selected_cnaes
    cnae_ids | [ main_cnae_id ]
  end
end
