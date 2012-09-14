class BankAccountCapabilitiesStatusChanger
  attr_accessor :bank_account, :update_date

  delegate :capabilities, :capabilities_without_status, :first_capability_without_status,
           :to => :bank_account, :allow_nil => true

  def initialize(bank_account, update_date)
    self.bank_account = bank_account
    self.update_date = update_date
  end

  def change!
    return if capabilities_without_status.empty?

    first = first_capability_without_status

    first.activate!(update_date)

    capabilities.each do |capability|
      next if capability == first

      capability.inactivate!(update_date)
    end
  end
end
