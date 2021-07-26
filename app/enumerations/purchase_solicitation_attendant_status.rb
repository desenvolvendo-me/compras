class PurchaseSolicitationAttendantStatus < EnumerateIt::Base
  associate_values :pending_completion, :released, :annuled
end