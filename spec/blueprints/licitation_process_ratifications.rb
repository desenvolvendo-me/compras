LicitationProcessRatification.blueprint(:processo_licitatorio_computador) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio_computador) }
  creditor { Creditor.make!(:wenderson_sa) }
  ratification_date { Date.current }
  adjudication_date { Date.current }
  sequence { 1 }
  licitation_process_ratification_items { [
    LicitationProcessRatificationItem.make!(:item,
      licitation_process_ratification: object,
      purchase_process_creditor_proposal: nil)
  ] }
end
