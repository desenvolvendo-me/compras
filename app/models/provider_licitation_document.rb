class ProviderLicitationDocument < ActiveRecord::Base
  attr_accessible :provider_id, :document_type_id, :document_number, :emission_date, :expiration_date

  belongs_to :provider
  belongs_to :document_type

  validates :document_type, :document_number, :emission_date, :expiration_date, :presence => true
  validates :document_number, :numericality => true
  validates :emission_date, :timeliness => { :on_or_after => Date.current, :type => :date }
end
