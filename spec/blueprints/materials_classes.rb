# encoding: utf-8
MaterialsClass.blueprint(:software) do
  class_number { "01" }
  mask { "99" }
  description { "Software" }
  details { "Softwares de computador" }
end

MaterialsClass.blueprint(:arames) do
  class_number { "02" }
  description { "Arames" }
  mask { "99.99.99.999.9999" }
  details { "Arames de aço e ferro" }
end

MaterialsClass.blueprint(:comp_eletricos) do
  class_number { "03" }
  mask { "99.99.99.999.99999" }
  description { "Componentes elétricos" }
  details { "Componentes elétricos" }
end
