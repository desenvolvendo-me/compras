SignatureConfigurationItem.blueprint(:primeiro_como_gerente) do
  order { 1 }
  signature { Signature.make!(:gerente_sobrinho) }
end

SignatureConfigurationItem.blueprint(:segundo_como_supervisor) do
  order { 2 }
  signature { Signature.make!(:supervisor_wenderson) }
end
