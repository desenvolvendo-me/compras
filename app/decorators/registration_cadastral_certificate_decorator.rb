class RegistrationCadastralCertificateDecorator
  include Decore
  include Decore::Proxy

  def number
    return '' if count_crc == 0
    component.count_crc
  end

  def signatures_grouped
    component.signatures.in_groups_of(4, false)
  end
end
