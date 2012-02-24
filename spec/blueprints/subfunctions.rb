# encoding: utf-8
Subfunction.blueprint(:geral) do
  code { "01" }
  description { "Administração Geral" }
  year { 2012 }
  entity { Entity.make!(:detran) }
  function { Function.make!(:administracao) }
end

Subfunction.blueprint(:gerente) do
  code { "02" }
  description { "Gerente Geral" }
  year { 2011 }
  entity { Entity.make!(:detran) }
  function { Function.make!(:administracao) }
end
