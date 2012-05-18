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

JudgmentForm.blueprint(:por_lote_com_melhor_tecnica) do
  description { 'Por Lote com Melhor Técnica' }
  kind { JudgmentFormKind::PART }
  licitation_kind { LicitationKind::BEST_TECHNIQUE }
end

JudgmentForm.blueprint(:global) do
  description { 'Por Lote com Melhor Técnica' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::BEST_TECHNIQUE }
end

JudgmentForm.blueprint(:por_lote_com_tecnica_e_preco) do
  description { 'Por Lote com Técnica e Preço' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::TECHNICAL_AND_PRICE }
end
