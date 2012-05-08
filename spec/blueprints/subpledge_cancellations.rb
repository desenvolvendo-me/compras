# encoding: utf-8
SubpledgeCancellation.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  subpledge { Subpledge.make!(:empenho_2012) }
  subpledge_expiration { SubpledgeExpiration.make!(:vencimento) }
  value { 1.00 }
  date { Date.current }
  reason { 'Falta de documentação' }
end
