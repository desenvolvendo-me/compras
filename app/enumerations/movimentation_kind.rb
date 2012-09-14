class MovimentationKind < EnumerateIt::Base
  associate_values :bilateral, :unilateral_borrowing, :unilaterial_creditor
end
