class BankAccountCapabilitiesStatusVerifier
  attr_accessor :capabilities, :update_date

  def initialize(capabilities, update_date)
    self.capabilities = capabilities
    self.update_date = update_date
  end

  def verify!
    capabilities_with_status_nil = capabilities.select { |c| c.status.nil? }

    return if capabilities_with_status_nil.empty?

    first = capabilities_with_status_nil.first

    first.active!
    first.date ||= update_date
    first.save!

    capabilities.select { |c| c != first }.each do |capability|
      capability.inactive!
      capability.date ||= update_date
      capability.inactivation_date = update_date
      capability.save!
    end
  end
end
