# encoding: utf-8
MaterialsClass.blueprint(:hortifrutigranjeiros) do
  materials_group { MaterialsGroup.make!(:alimenticios) }
  class_number { "01" }
  description { "Hortifrutigranjeiros" }
  details { "detalhamento da classe material" }
end

MaterialsClass.blueprint(:pecas) do
  materials_group { MaterialsGroup.make!(:limpeza) }
  class_number { "02" }
  description { "Peças" }
  details { "detalhamento da classe material" }
end
