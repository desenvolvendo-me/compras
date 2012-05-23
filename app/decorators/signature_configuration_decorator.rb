class SignatureConfigurationDecorator < Decorator
  def availables(signature_report = ::SignatureReport)
    if component.report
      signature_report.availables + signature_report.to_a_by_keys(component.report)
    else
      signature_report.availables
    end
  end
end
