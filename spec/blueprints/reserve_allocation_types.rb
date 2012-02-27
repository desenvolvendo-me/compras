# encoding: utf-8
ReserveAllocationType.blueprint(:comum) do
  description { 'Comum' }
  status { Status::ACTIVE }
end

ReserveAllocationType.blueprint(:licitation) do
  description { 'Licitação' }
  status { Status::ACTIVE }
end
