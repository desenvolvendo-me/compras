# encoding: utf-8
DisseminationSource.blueprint(:jornal_municipal) do
  communication_source { CommunicationSource.make(:jornal_municipal) }
  description { 'Jornal Oficial do Município' }
end

DisseminationSource.blueprint(:jornal_bairro) do
  communication_source { CommunicationSource.make(:jornal_municipal) }
  description { 'Jornal Oficial do Bairro' }
end
