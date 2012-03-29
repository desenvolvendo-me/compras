PledgeExpiration.blueprint(:vencimento) do
  expiration_date { Date.current + 1.day }
  value { 9.99 }
  number { 1 }
end
