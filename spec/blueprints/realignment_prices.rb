RealignmentPrice.blueprint(:realinhamento) do
  purchase_process { LicitationProcess.make!(:apuracao_por_lote) }
  creditor { Creditor.make!(:wenderson_sa) }
  lot { 55 }
end
