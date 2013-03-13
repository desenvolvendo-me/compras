# encoding: utf-8
Prefecture.blueprint(:belo_horizonte) do
  name { "Belo Horizonte" }
  cnpj { "48.021.328/0001-10" }
  phone { "(31) 9999-0909" }
  fax { "(31) 2343-8908" }
  email { "belo_horizonte@belohorizonte.com.br" }
  mayor_name { "Márcio Lacerda" }
  address { Address.make!(:apto, :addressable => object) }
  setting { Setting.make!(:parametros_prefeitura, :prefecture => object) }
end