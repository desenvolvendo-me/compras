JudgmentCommissionAdvice.blueprint(:parecer) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  licitation_commission { LicitationCommission.make!(:comissao) }
  minutes_number { 1 }
  year { 2012 }
  judgment_sequence { 1 }
  judgment_commission_advice_members { [JudgmentCommissionAdviceMember.make!(:membro)] }
end
