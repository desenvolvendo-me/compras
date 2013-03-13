Descriptor.blueprint(:detran_2011) do
  entity { Entity.make!(:detran) }
  period { Date.new(2011, 10, 1) }
end

Descriptor.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  period { Date.new(2012, 10, 1) }
end

Descriptor.blueprint(:secretaria_de_educacao_2011) do
  entity { Entity.make!(:secretaria_de_educacao) }
  period { Date.new(2011, 10, 1) }
end

Descriptor.blueprint(:secretaria_de_educacao_2012) do
  entity { Entity.make!(:secretaria_de_educacao) }
  period { Date.new(2012, 10, 1) }
end