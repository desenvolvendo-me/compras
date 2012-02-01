# encoding: utf-8
MaterialsGroup.blueprint(:alimenticios) do
  group { "01" }
  name { "Generos alimenticios" }
end

MaterialsGroup.blueprint(:limpeza) do
  group { "02" }
  name { "Limpeza" }
end

MaterialsGroup.blueprint(:escritorio) do
  group { "03" }
  name { "Escritório" }
end
