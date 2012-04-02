PledgeExpiration.blueprint(:vencimento) do
  expiration_date { Date.current + 1.day }
  value { 9.99 }
  number { 1 }
end

PledgeExpiration.blueprint(:vencimento_primario) do
  expiration_date { Date.current + 1.day }
  value { 100 }
  number { 1 }
end

PledgeExpiration.blueprint(:vencimento_secundario) do
  expiration_date { Date.current + 2.day }
  value { 100 }
  number { 2 }
end
