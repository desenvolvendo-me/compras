class SignatureConfigurationItem < ActiveRecord::Base
  attr_accessible :signature_configuration_id, :signature_id, :order

  belongs_to :signature_configuration
  belongs_to :signature

  delegate :position, :to => :signature, :allow_nil => true

  validates :order, :signature, :presence => true
end
