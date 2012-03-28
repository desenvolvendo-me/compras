# encoding: utf-8
Function.blueprint(:administracao) do
  code { "04" }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Administração" }
end

Function.blueprint(:execucao) do
  code { "05" }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Execução" }
end
