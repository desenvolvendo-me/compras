class DebtParcelStatus < EnumerateIt::Base
  associate_values :open, :cancelled, :paid, :deleted, :transferred, :suspended, :redeemed, :parceled
end
