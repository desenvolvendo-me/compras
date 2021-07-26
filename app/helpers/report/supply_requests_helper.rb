
module Report::SupplyRequests

  def self.secretary_settings?(object)
    object&.secretary_settings&.blank? ? "Por favor cadastre sua assinatura digital para aprovar o pedido." : ''
  end

end