# encoding: utf-8
LicitationCommission.blueprint(:comissao) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  commission_type { CommissionType::TRADING }
  nomination_date { Date.new(2012, 3, 20) }
  expiration_date { Date.new(2012, 3, 22) }
  exoneration_date { Date.new(2012, 3, 25) }
  description { "descricao da comissao" }
  licitation_commission_responsibles { [LicitationCommissionResponsible.make!(:advogado)] }
  licitation_commission_members { [LicitationCommissionMember.make!(:membro_presidente)] }
end

LicitationCommission.blueprint(:comissao_nova) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  commission_type { CommissionType::TRADING }
  nomination_date { Date.new(2012, 4, 20) }
  expiration_date { Date.new(2012, 4, 22) }
  exoneration_date { Date.new(2012, 4, 25) }
  description { "descricao da comissao" }
  licitation_commission_responsibles { [LicitationCommissionResponsible.make!(:advogado)] }
  licitation_commission_members { [LicitationCommissionMember.make!(:membro), LicitationCommissionMember.make!(:membro_presidente)] }
end

LicitationCommission.blueprint(:comissao_pregao_presencial) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  commission_type { CommissionType::TRADING }
  nomination_date { Date.new(2012, 3, 20) }
  expiration_date { Date.new(2012, 3, 22) }
  exoneration_date { Date.new(2012, 3, 25) }
  description { "Comissão para pregão presencial" }
  licitation_commission_responsibles { [LicitationCommissionResponsible.make!(:advogado)] }
  licitation_commission_members {
    [LicitationCommissionMember.make!(:membro_presidente),
     LicitationCommissionMember.make!(:membro_pregoeiro),
     LicitationCommissionMember.make!(:membro_equipe_apoio)]
  }
end
