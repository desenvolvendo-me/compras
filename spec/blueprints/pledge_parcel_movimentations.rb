PledgeParcelMovimentation.blueprint(:empenho) do
  pledge_parcel { PledgeParcel.make!(:vencimento) }
  pledge_parcel_modificator { PledgeCancellation.make!(:empenho_2012) }
  pledge_parcel_value_was { 9.99 }
  pledge_parcel_value { 8.99 }
  value { 1 }
end
