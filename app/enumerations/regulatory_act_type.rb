class RegulatoryActType < EnumerateIt::Base
  associate_values :budget_change,
                   :establishes_licitation_comission,
                   :ldo,:loa,:ppa,
                   :regulamentation_of_price_registration,
                   :regulamentation_of_trading
  
end
