PledgeParcelMovimentation.blueprint(:empenho) do
  pledge_parcel { PledgeParcel.make!(:vencimento) }
  pledge_parcel_modificator { PledgeCancellation.make!(:empenho_2012) }
  pledge_parcel_value_was { 9.99 }
  pledge_parcel_value { 8.99 }
  value { 1 }
end

PledgeParcelMovimentation.blueprint(:liquidacao_parcial) do
  pledge_parcel { PledgeParcel.make!(:vencimento) }
  pledge_parcel_modificator { PledgeLiquidation.make!(:liquidacao_parcial) }
  pledge_parcel_value_was { 9.99 }
  pledge_parcel_value { 8.99 }
  value { 1 }
end

PledgeParcelMovimentation.blueprint(:liquidacao_total) do
  pledge_parcel { PledgeParcel.make!(:vencimento) }
  pledge_parcel_modificator { PledgeLiquidation.make!(:liquidacao_total) }
  pledge_parcel_value_was { 9.99 }
  pledge_parcel_value { 0 }
  value { 9.99 }
end
