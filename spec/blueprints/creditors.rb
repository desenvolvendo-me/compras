Creditor.blueprint(:nohup) do
  name { 'Nohup LTDA.' }
  status { Status::ACTIVE }
  entity { Entity.make!(:detran) }
end
