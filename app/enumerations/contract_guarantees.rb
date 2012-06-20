class ContractGuarantees < EnumerateIt::Base
  associate_values :without, :bank, :insurance, :cash_bond, :public_debt_securities
end
