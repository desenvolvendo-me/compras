#encoding: utf-8
JudgmentCommissionAdvice.blueprint(:parecer) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  licitation_commission { LicitationCommission.make!(:comissao) }
  minutes_number { 1 }
  year { 2012 }
  judgment_sequence { 1 }
  judgment_start_date { Date.new(2012, 2, 20) }
  judgment_start_time { "12:00" }
  judgment_end_date { Date.new(2012, 2, 20) }
  judgment_end_time { "13:00" }
  companies_minutes { "Texto da ata sobre as empresas licitantes" }
  companies_documentation_minutes { "Texto da ata sobre documentação das empresas licitantes" }
  justification_minutes { "Texto da ata sobre julgamento das propostas / justificativas" }
  judgment_minutes { "Texto da ata sobre julgamento - pareceres diversos" }
end
