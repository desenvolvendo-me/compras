# encoding: utf-8
MaterialsClass.blueprint(:hortifrutigranjeiros) do
  materials_group { MaterialsGroup.make!(:first) }
  name { "Hortifrutigranjeiros" }
  description { "detalhamento da classe material" }
end

MaterialsClass.blueprint(:pecas) do
  materials_group { MaterialsGroup.make!(:first) }
  name { "Peças" }
  description { "detalhamento da classe material" }
end
