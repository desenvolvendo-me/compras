SignatureConfiguration.blueprint(:autorizacoes_de_fornecimento) do
  report { SignatureReport::SUPPLY_AUTHORIZATIONS }
  signature_configuration_items { [SignatureConfigurationItem.make!(:primeiro_como_gerente)] }
end

SignatureConfiguration.blueprint(:homologacao_e_adjudicao_do_processo_licitatorio) do
  report { SignatureReport::LICITATION_PROCESS_RATIFICATIONS }
  signature_configuration_items { [
    SignatureConfigurationItem.make!(:primeiro_como_gerente),
    SignatureConfigurationItem.make!(:segundo_como_supervisor)
  ] }
end

SignatureConfiguration.blueprint(:crc) do
  report { SignatureReport::REGISTRATION_CADASTRAL_CERTIFICATES }
  signature_configuration_items { [SignatureConfigurationItem.make!(:primeiro_como_gerente)] }
end
