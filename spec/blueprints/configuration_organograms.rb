# encoding: utf-8
ConfigurationOrganogram.blueprint(:detran_sopa) do
  entity { Entity.make!(:detran) }
  administractive_act { AdministractiveAct.make!(:sopa) }
  name { 'Configuração do Detran' }
end
