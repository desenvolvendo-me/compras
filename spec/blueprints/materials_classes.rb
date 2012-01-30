# encoding: utf-8
MaterialsClass.blueprint(:hortifrutigranjeiros) do
  materials_group { MaterialsGroup.make!(:alimenticios) }
  class_number { "01" }
  name { "Hortifrutigranjeiros" }
  description { "detalhamento da classe material" }
end

MaterialsClass.blueprint(:pecas) do
  materials_group { MaterialsGroup.make!(:alimenticios) }
  class_number { "02" }
  name { "Peças" }
  description { "detalhamento da classe material" }
end
