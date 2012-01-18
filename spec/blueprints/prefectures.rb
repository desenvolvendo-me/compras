# encoding: utf-8
Prefecture.blueprint(:belo_horizonte) do
  name { "Belo Horizonte" }
  cnpj { "48.021.328/0001-10" }
  phone { "(31) 9999-0909" }
  fax { "(31) 2343-8908" }
  email { "belo_horizonte@belohorizonte.com.br" }
  mayor_name { "Márcio Lacerda" }
  address { Address.make!(:apto, :addressable => object) }
end

Prefecture.blueprint(:porto_alegre) do
  name { "Porto Alegre" }
  cnpj { "11.098.229/0001-27" }
  phone { "(51) 8990-0909" }
  fax { "(51) 3444-8908" }
  email { "porto_alegre@portoalegre.com.br" }
  mayor_name { "João da Silva" }
  address { Address.make!(:house, :addressable => object) }
end
