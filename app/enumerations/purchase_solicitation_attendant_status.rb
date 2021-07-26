class PurchaseSolicitationAttendantStatus < EnumerateIt::Base
  associate_values :pending_completion, :refused, :released, :annuled
end