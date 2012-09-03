LicitationProcessBidder.blueprint(:licitante) do
  creditor { Creditor.make!(:wenderson_sa) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  people { [Person.make!(:sobrinho)] }
  technical_score { 50 }
end

LicitationProcessBidder.blueprint(:licitante_sobrinho) do
  creditor { Creditor.make!(:sobrinho_sa) }
  invited { true }
  protocol { "123453" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_1) do
  creditor { Creditor.make!(:wenderson_sa) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_1)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_2) do
  creditor { Creditor.make!(:sobrinho_sa) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_2)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_3) do
  creditor { Creditor.make!(:nohup) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_3)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_4) do
  creditor { Creditor.make!(:ibm) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_4)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_5) do
  creditor { Creditor.make!(:sobrinho_sa) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_5)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_6) do
  creditor { Creditor.make!(:wenderson_sa) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_1)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_7) do
  creditor { Creditor.make!(:ibm) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_7)] }
  technical_score { 100 }
end

LicitationProcessBidder.blueprint(:licitante_com_proposta_8) do
  creditor { Creditor.make!(:nohup) }
  invited { true }
  protocol { "123456" }
  protocol_date { Date.current }
  receipt_date { Date.tomorrow }
  documents { [LicitationProcessBidderDocument.make!(:documento)] }
  proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_6)] }
  technical_score { 100 }
end
