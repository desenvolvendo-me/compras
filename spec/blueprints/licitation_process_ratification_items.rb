LicitationProcessRatificationItem.blueprint(:item) do
  ratificated { true }
  licitation_process_ratification {
    LicitationProcessRatification.make!(:processo_licitatorio_computador)
  }
  purchase_process_creditor_proposal {
    PurchaseProcessCreditorProposal.make!(:proposta_arame)
  }
end
