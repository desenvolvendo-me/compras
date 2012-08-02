LicitationProcessRatification.blueprint(:processo_licitatorio_computador) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio_computador) }
  licitation_process_bidder { LicitationProcessBidder.make!(:licitante) }
  ratification_date { Date.current }
  adjudication_date { Date.current }
  licitation_process_bidder_proposals { [LicitationProcessBidderProposal.make!(:proposta_licitante_1, :licitation_process_bidder => LicitationProcessBidder.make!(:licitante))] }
  sequence { 1 }
end
