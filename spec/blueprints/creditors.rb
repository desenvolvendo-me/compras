Creditor.blueprint(:nohup) do
  name { 'Nohup LTDA.' }
  status { Status::ACTIVE }
  entity { Entity.make!(:detran) }
end

Creditor.blueprint(:nobe) do
  name { 'Nobe' }
  status { Status::ACTIVE }
  entity { Entity.make!(:detran) }
end
