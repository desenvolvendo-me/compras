Condominium.blueprint(:tambuata) do
  name               { 'Tambuata' }
  condominium_type   { CondominiumType::VERTICAL }
end

Condominium.blueprint(:parque_das_flores) do
  name               { "Parque das Flores" }
  condominium_type   { CondominiumType::HORIZONTAL }
end
