JudgmentForm.blueprint(:global_com_menor_preco) do
  description { 'Forma Global com Menor Preço' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::LOWEST_PRICE }
  enabled { true }
end

JudgmentForm.blueprint(:por_item_com_melhor_tecnica) do
  description { 'Por Item com Melhor Técnica' }
  kind { JudgmentFormKind::ITEM }
  licitation_kind { LicitationKind::BEST_TECHNIQUE }
  enabled { true }
end

JudgmentForm.blueprint(:por_lote_com_melhor_tecnica) do
  description { 'Por Lote com Melhor Técnica' }
  kind { JudgmentFormKind::LOT }
  licitation_kind { LicitationKind::BEST_TECHNIQUE }
  enabled { true }
end

JudgmentForm.blueprint(:global) do
  description { 'Por Lote com Melhor Técnica' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::BEST_TECHNIQUE }
  enabled { true }
end

JudgmentForm.blueprint(:por_lote_com_tecnica_e_preco) do
  description { 'Por Lote com Técnica e Preço' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::TECHNICAL_AND_PRICE }
  enabled { true }
end

JudgmentForm.blueprint(:global_com_melhor_lance_ou_oferta) do
  description { 'Global com Melhor Lance ou Oferta' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::BEST_AUCTION_OR_OFFER }
  enabled { true }
end

JudgmentForm.blueprint(:por_item_com_menor_preco) do
  description { 'Por Item com Menor Preço' }
  kind { JudgmentFormKind::ITEM }
  licitation_kind { LicitationKind::LOWEST_PRICE }
  enabled { true }
end

JudgmentForm.blueprint(:por_lote_com_menor_preco) do
  description { 'Por Lote com Menor Preço' }
  kind { JudgmentFormKind::LOT }
  licitation_kind { LicitationKind::LOWEST_PRICE }
  enabled { true }
end

JudgmentForm.blueprint(:maior_desconto_por_tabela) do
  description { 'Maior Desconto por Tabela' }
  kind { JudgmentFormKind::GLOBAL }
  licitation_kind { LicitationKind::HIGHER_DISCOUNT_ON_TABLE }
  enabled { true }
end
