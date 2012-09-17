LicitationProcessRatification.blueprint(:processo_licitatorio_computador) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio_computador) }
  bidder { Bidder.make!(:licitante) }
  ratification_date { Date.current }
  adjudication_date { Date.current }
  bidder_proposals { [BidderProposal.make!(:proposta_licitante_1, :bidder => Bidder.make!(:licitante))] }
  sequence { 1 }
end
