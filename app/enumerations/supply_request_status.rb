class SupplyRequestStatus < EnumerateIt::Base
  associate_values :sent,:in_service,:delivered,:pending,:financial_analysis,:secretary_analysis, :finished
end