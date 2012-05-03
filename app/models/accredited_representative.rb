class AccreditedRepresentative < ActiveRecord::Base
  attr_accessible :accreditation_id, :individual_id, :provider_id, :role

  attr_accessor :number

  belongs_to :accreditation
  belongs_to :individual
  belongs_to :provider

  validates :accreditation, :provider, :individual, :role, :presence => true

  validate :cannot_have_providers_that_are_not_in_licitation_process

  protected

  def provider_is_in_licitation_process?
    return false unless accreditation && provider

    licitation_process = provider.licitation_processes.find_by_id(accreditation.licitation_process_id)

    !licitation_process.nil?
  end

  def cannot_have_providers_that_are_not_in_licitation_process
    return unless accreditation && provider

    if !provider_is_in_licitation_process?
      errors.add(:provider, :cannot_have_providers_that_are_not_in_licitation_process)
    end
  end
end
