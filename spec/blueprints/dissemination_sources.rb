# encoding: utf-8
DisseminationSource.blueprint(:jornal_municipal) do
  communication_source { CommunicationSource.make(:jornal_municipal) }
  name { 'Jornal Oficial do Município' }
end
