# encoding: utf-8
GovernmentProgram.blueprint(:habitacao) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  description { 'Habitação' }
  status { Status::ACTIVE }
end
