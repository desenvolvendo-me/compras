LicitationCommission.blueprint(:comissao) do
  commission_type { CommissionType::TRADING }
  nomination_date { "20/03/2012" }
  expiration_date { "22/03/2012" }
  exoneration_date { "25/03/2012" }
  description { "descricao da comissao" }
end
