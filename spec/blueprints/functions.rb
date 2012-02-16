# encoding: utf-8
Function.blueprint(:administracao) do
  code { "04" }
  administractive_act { AdministractiveAct.make!(:sopa) }
  description { "Administração" }
end
