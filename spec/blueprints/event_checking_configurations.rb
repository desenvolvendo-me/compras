# encoding: utf-8
EventCheckingConfiguration.blueprint(:detran) do
  descriptor { Descriptor.make!(:detran_2012) }
  event { "Evento Tal" }
  function { "Função Tal" }
  accounts { [EventCheckingAccount.make!(:disponibilidade_financeira)] }
end
