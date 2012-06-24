# encoding: utf-8
GovernmentProgram.blueprint(:habitacao) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { 'Habitação' }
  status { Status::ACTIVE }
end

GovernmentProgram.blueprint(:educacao) do
  descriptor { Descriptor.make!(:secretaria_de_educacao_2012) }
  description { 'Educação' }
  status { Status::ACTIVE }
end
