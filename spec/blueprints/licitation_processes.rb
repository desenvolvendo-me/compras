LicitationProcess.blueprint(:processo_licitatorio) do
  year { 2012 }
  process_date { "2012-03-19" }
  bid_opening { BidOpening.make!(:compra_de_cadeiras) }
  object_description { "Descricao" }
  capability { Capability.make!(:reforma) }
  expiration { "10 dias" }
  readjustment_index { "XPTO" }
  period { Period.make!(:um_ano) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { "2012-03-19" }
  contract_date { "2012-03-19" }
  contract_expiration { 3 }
  observations { "observacoes" }
end
