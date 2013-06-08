class RegulatoryActType < EnumerateIt::Base
  associate_values :ppa => 6,
                   :ldo => 5,
                   :loa => 4,
                   :budget_change => 3,
                   :regulamentation_of_price_registration => 1,
                   :regulamentation_of_trading => 2
end
