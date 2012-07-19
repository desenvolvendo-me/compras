class SignatureReport < EnumerateIt::Base
  associate_values :supply_authorizations, :administrative_processes, :registration_cadastral_certificates

  def self.availables
    to_a_by_keys(availables_keys)
  end

  def self.availables_keys
    list - unavailables_keys
  end

  def self.unavailables_keys(signature_configuration = SignatureConfiguration)
    signature_configuration.unavailables_reports
  end

  def self.to_a_by_keys(keys)
    to_a.select do |signature_report|
      keys.include?(signature_report.last)
    end
  end
end
