Indexer.blueprint(:selic) do
  name { 'SELIC' }
  currency { Currency.make!(:real) }
  indexer_values { [IndexerValue.make!(:selic)] }
end

Indexer.blueprint(:xpto) do
  name { 'XPTO' }
  currency { Currency.make!(:real) }
  indexer_values { [IndexerValue.make!(:selic)] }
end
