SignatureConfigurationItem.blueprint(:primeiro_como_gerente) do
  order { 1 }
  signature { Signature.make!(:gerente_sobrinho) }
end
