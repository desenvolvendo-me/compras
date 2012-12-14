Trading.blueprint(:pregao_presencial) do
  year { 2012 }
  code { 1 }
  licitation_process { LicitationProcess.make!(:pregao_presencial) }
  trading_items {
    [TradingItem.make!(:item_pregao_presencial)]
  }
end
