LicitationProcessInvitedBidder.blueprint(:licitante) do
  provider { Provider.make!(:wenderson_sa) }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  licitation_process_invited_bidder_documents { [LicitationProcessInvitedBidderDocument.make!(:documento)] }
end

LicitationProcessInvitedBidder.blueprint(:licitante_sobrinho) do
  provider { Provider.make!(:sobrinho_sa) }
  protocol { "123453" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  licitation_process_invited_bidder_documents { [LicitationProcessInvitedBidderDocument.make!(:documento)] }
end
