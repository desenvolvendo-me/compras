Accreditation.blueprint(:credenciamento) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio_fornecedores) }
  licitation_commission { LicitationCommission.make!(:comissao) }
end

Accreditation.blueprint(:credenciamento_com_presidente) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio_fornecedores) }
  licitation_commission { LicitationCommission.make!(:comissao_nova) }
end
