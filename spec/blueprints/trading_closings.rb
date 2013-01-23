# encoding: utf-8

TradingClosing.blueprint(:encerramento) do
  status { TradingClosingStatus::ABANDONED }
  observation { 'Encerramento do pregão' }
end
