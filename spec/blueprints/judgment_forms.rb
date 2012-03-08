# encoding: utf-8
JudgmentForm.blueprint(:global_com_menor_preco) do
  description { 'Forma Global com Menor Preço' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::LOWEST_PRICE }
end

JudgmentForm.blueprint(:por_item_com_melhor_tecnica) do
  description { 'Por Item com Melhor Técnica' }
  kind { JudgmentFormKind::ITEM }
  licitation_kind { LicitationKind::BEST_TECHNIQUE }
end
