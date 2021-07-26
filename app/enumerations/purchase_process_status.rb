class PurchaseProcessStatus < EnumerateIt::Base
  associate_values :annulled, :in_progress, :waiting_for_open, :approved, :closed
end
