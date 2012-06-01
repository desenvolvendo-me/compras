SignatureConfiguration.blueprint(:autorizacoes_de_fornecimento) do
  report { SignatureReport::SUPPLY_AUTHORIZATIONS }
  signature_configuration_items { [SignatureConfigurationItem.make!(:primeiro_como_gerente)] }
end

SignatureConfiguration.blueprint(:processo_administrativo) do
  report { SignatureReport::ADMINISTRATIVE_PROCESSES }
  signature_configuration_items { [
    SignatureConfigurationItem.make!(:primeiro_como_gerente),
    SignatureConfigurationItem.make!(:segundo_como_supervisor)
  ] }
end
