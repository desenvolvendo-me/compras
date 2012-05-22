SubpledgeExpiration.blueprint(:vencimento) do
  expiration_date { Date.current + 8.days }
  value { 1.00 }
  number { 1 }
end

SubpledgeExpiration.blueprint(:vencimento_primario) do
  expiration_date { Date.current + 30.days }
  value { 60.00 }
  number { 1 }
end

SubpledgeExpiration.blueprint(:vencimento_secundario) do
  expiration_date { Date.current + 60.days }
  value { 40.00 }
  number { 2 }
end
