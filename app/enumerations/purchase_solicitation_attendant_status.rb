class PurchaseSolicitationAttendantStatus < EnumerateIt::Base
  associate_values :pending_completion, :released, :annuled, :rejected
end