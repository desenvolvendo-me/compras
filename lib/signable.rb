module Signable
  def signatures(signature_configuration_item = SignatureConfigurationItem, signature_report = SignatureReport)
    signature_configuration_item.all_by_configuration_report(signature_report.value_for(as_enumeration_key))
  end

  private

  def as_enumeration_key
    self.class.name.underscore.pluralize.upcase
  end
end
