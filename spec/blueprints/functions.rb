# encoding: utf-8
Function.blueprint(:administracao) do
  code { "04" }
  administractive_act { AdministractiveAct.make!(:sopa) }
  description { "Administração" }
end

Function.blueprint(:execucao) do
  code { "05" }
  administractive_act { AdministractiveAct.make!(:sopa) }
  description { "Execução" }
end
