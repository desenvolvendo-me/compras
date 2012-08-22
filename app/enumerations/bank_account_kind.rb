class BankAccountKind < EnumerateIt::Base
  associate_values :treasury,
                   :moviment,
                   :linked,
                   :savings,
                   :application
end
