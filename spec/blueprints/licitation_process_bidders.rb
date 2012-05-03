LicitationProcessBidder.blueprint(:licitante) do
  provider { Provider.make!(:wenderson_sa) }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
end

LicitationProcessBidder.blueprint(:licitante_sobrinho) do
  provider { Provider.make!(:sobrinho_sa) }
  protocol { "123453" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
end
