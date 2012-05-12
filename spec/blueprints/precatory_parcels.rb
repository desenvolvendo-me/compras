#encoding: utf-8

PrecatoryParcel.blueprint(:parcela_paga) do
  expiration_date { Date.new(2012, 5, 12) }
  value { 5000000.0 }
  situation { PrecatoryParcelSituation::PAID }
  payment_date { Date.new(2012, 5, 12) }
  amount_paid { 5000000.0 }
  observation { "pagamento efetuado" }
end

PrecatoryParcel.blueprint(:parcela_a_vencer) do
  expiration_date { Date.new(2012, 5, 20) }
  value { 1000000.0 }
  situation { PrecatoryParcelSituation::TO_EXPIRE }
  payment_date { '' }
  amount_paid { 0.0 }
  observation { "" } 
end
