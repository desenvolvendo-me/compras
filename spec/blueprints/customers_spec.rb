Customer.blueprint(:cliente) do
  name { 'Nohup' }
  domain { '127.0.0.1' }
  database { 'test' }
  secret_token { '1234' }
end
