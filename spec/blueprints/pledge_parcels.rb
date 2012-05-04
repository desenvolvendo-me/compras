PledgeParcel.blueprint(:vencimento) do
  expiration_date { Date.current + 1.day }
  value { 9.99 }
  number { 1 }
end

PledgeParcel.blueprint(:vencimento_primario) do
  expiration_date { Date.current + 1.day }
  value { 100 }
  number { 1 }
end

PledgeParcel.blueprint(:vencimento_secundario) do
  expiration_date { Date.current + 2.day }
  value { 100 }
  number { 2 }
end

PledgeParcel.blueprint(:vencimento_para_empenho_em_quinze_dias) do
  expiration_date { Date.current + 20.day }
  value { 9.99 }
  number { 1 }
end
