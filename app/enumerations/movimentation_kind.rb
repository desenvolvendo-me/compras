class MovimentationKind < EnumerateIt::Base
  associate_values :bilateral, :unilateral_borrowing, :unilateral_creditor
end
