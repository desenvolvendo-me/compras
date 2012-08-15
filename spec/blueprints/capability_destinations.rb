# encoding: utf-8
CapabilityDestination.blueprint(:linha_de_credito) do
  capability_destination_use { CapabilityDestinationUse::DONATIONS }
  capability_destination_group { CapabilityDestinationGroup::CONDITIONAL }
  specification { 1 }
  description { "Programa de linha de crédito" }
  destination { CapabilityDestinationKind::PRIMARY }
end
