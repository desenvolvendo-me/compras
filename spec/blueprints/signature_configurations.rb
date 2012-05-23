SignatureConfiguration.blueprint(:autorizacoes_de_fornecimento) do
  report { SignatureReport::SUPPLY_AUTHORIZATIONS }
  signature_configuration_items { [SignatureConfigurationItem.make!(:primeiro_como_gerente)] }
end
