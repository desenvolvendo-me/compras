LicitationProcessInvitedBidder.blueprint(:licitante) do
  provider { Provider.make!(:wenderson_sa) }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
end
