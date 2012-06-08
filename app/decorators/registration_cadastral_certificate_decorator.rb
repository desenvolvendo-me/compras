class RegistrationCadastralCertificateDecorator < Decorator
  def number
    return '' if count_crc == 0
    component.count_crc
  end
end
