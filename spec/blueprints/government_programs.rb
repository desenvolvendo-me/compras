# encoding: utf-8
GovernmentProgram.blueprint(:habitacao) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  description { 'Habitação' }
  status { Status::ACTIVE }
end

GovernmentProgram.blueprint(:educacao) do
  entity { Entity.make!(:secretaria_de_educacao) }
  year { 2012 }
  description { 'Educação' }
  status { Status::ACTIVE }
end
