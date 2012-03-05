# encoding: utf-8
MaterialsClass.blueprint(:software) do
  materials_group { MaterialsGroup.make!(:informatica) }
  class_number { "01" }
  description { "Software" }
  details { "Softwares de computador" }
end

MaterialsClass.blueprint(:arames) do
  materials_group { MaterialsGroup.make!(:ferro_aco) }
  class_number { "02" }
  description { "Arames" }
  details { "Arames de aço e ferro" }
end

MaterialsClass.blueprint(:comp_eletricos) do
  materials_group { MaterialsGroup.make!(:comp_eletricos_eletronicos) }
  class_number { "03" }
  description { "Componentes elétricos" }
  details { "Componentes elétricos" }
end
