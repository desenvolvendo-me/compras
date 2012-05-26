class Creditor < ActiveRecord::Base
  attr_accessible :person_id, :occupation_classification_id, :company_size_id
  attr_accessible :main_cnae_id, :municipal_public_administration, :autonomous
  attr_accessible :social_identification_number, :choose_simple
  attr_accessible :contract_start_date

  belongs_to :person
  belongs_to :occupation_classification
  belongs_to :company_size
  belongs_to :main_cnae, :class_name => 'Cnae'

  delegate :personable_type, :to => :person, :allow_nil => true

  validates :person, :presence => true
  validates :contract_start_date,
    :presence => { :if => :autonomous? },
    :timeliness => { :type => :date, :allow_blank => true }
  validates :company_size, :main_cnae, :presence => { :if => :company? }

  orderize :id
  filterize

  def to_s
    person.to_s
  end

  protected

  def company?
    person_id? && person.company?
  end
end
