# encoding: utf-8
Subfunction.blueprint(:geral) do
  descriptor { Descriptor.make!(:detran_2012) }
  code { "01" }
  description { "Administração Geral" }
  function { Function.make!(:administracao) }
end

Subfunction.blueprint(:gerente) do
  descriptor { Descriptor.make!(:detran_2011) }
  code { "02" }
  description { "Gerente Geral" }
  function { Function.make!(:administracao) }
end

Subfunction.blueprint(:supervisor) do
  descriptor { Descriptor.make!(:detran_2011) }
  code { "02" }
  description { "Supervisor" }
  function { Function.make!(:execucao) }
end
