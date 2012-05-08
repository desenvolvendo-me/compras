SubpledgeExpiration.blueprint(:vencimento) do
  expiration_date { Date.current + 8.days }
  value { 1.00 }
  number { 1 }
end
