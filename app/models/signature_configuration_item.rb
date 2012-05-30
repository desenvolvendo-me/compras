class SignatureConfigurationItem < ActiveRecord::Base
  attr_accessible :signature_configuration_id, :signature_id, :order

  belongs_to :signature_configuration
  belongs_to :signature

  delegate :person, :position, :to => :signature, :allow_nil => true

  validates :order, :signature, :presence => true

  def self.all_by_configuration_report(report_name)
    joins { signature_configuration }.
    where { signature_configuration.report.eq(report_name) }
  end
end
