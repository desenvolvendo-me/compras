LicitationCommission.blueprint(:comissao) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  commission_type { CommissionType::TRADING }
  nomination_date { Date.new(2012, 3, 20) }
  expiration_date { Date.new(2012, 3, 22) }
  exoneration_date { Date.new(2012, 3, 25) }
  description { "descricao da comissao" }
end
