# encoding: utf-8
MaterialsClass.blueprint(:software) do
  masked_number { "01.32.00.000.000" }
  mask { "99.99.99.999.999" }
  description { "Software" }
  details { "Softwares de computador" }
end

MaterialsClass.blueprint(:arames) do
  masked_number { "02.44.65.430.000" }
  description { "Arames" }
  mask { "99.99.99.999.999" }
  details { "Arames de aço e ferro" }
end

MaterialsClass.blueprint(:comp_eletricos) do
  masked_number { "03.05.33.000.00000" }
  mask { "99.99.99.999.99999" }
  description { "Componentes elétricos" }
  details { "Componentes elétricos" }
end
