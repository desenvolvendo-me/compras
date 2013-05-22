LicitationProcessRatification.blueprint(:processo_licitatorio_computador) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio_computador) }
  bidder { Bidder.make!(:licitante) }
  ratification_date { Date.current }
  adjudication_date { Date.current }
  sequence { 1 }
end
