# encoding: utf-8
Subfunction.blueprint(:geral) do
  code { "01" }
  description { "Administração Geral" }
  function { Function.make!(:administracao) }
end

Subfunction.blueprint(:gerente) do
  code { "02" }
  description { "Gerente Geral" }
  function { Function.make!(:administracao) }
end
