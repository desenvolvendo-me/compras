# encoding: utf-8
GovernmentProgram.blueprint(:habitacao) do
  code { "003" }
  description { 'Habitação' }
  status { Status::ACTIVE }
end

GovernmentProgram.blueprint(:educacao) do
  code { "003" }
  description { 'Educação' }
  status { Status::ACTIVE }
end
