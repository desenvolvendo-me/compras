Condominium.blueprint(:tambuata) do
  name               { "Tambuata" }
  quantity_garages   { 5 }
  quantity_units     { 4 }
  quantity_blocks    { 3 }
  quantity_elevators { 4 }
  quantity_rooms     { 4 }
  quantity_floors    { 3 }
  built_area         { 45.34 }
  area_common_user   { 25.78 }
  construction_year  { "1900" }
  condominium_type   { CondominiumType.make!(:vertical) }
  address            { Address.make(:apto, :condominium => object) }
end

Condominium.blueprint(:parque_das_flores) do
  name               { "Parque das Flores" }
  quantity_garages   { 5 }
  quantity_units     { 4 }
  quantity_blocks    { 3 }
  quantity_elevators { 4 }
  quantity_rooms     { 4 }
  quantity_floors    { 3 }
  built_area         { 45.34 }
  area_common_user   { 25.78 }
  construction_year  { "1900" }
  condominium_type   { CondominiumType.make!(:horizontal) }
  address            { Address.make(:apto, :condominium => object) }
end
