# encoding: utf-8
JudgmentForm.blueprint(:global_com_menor_preco) do
  description { 'Forma Global com Menor Preço' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::LOWEST_PRICE }
end
