class PurchaseSolicitationAttendantStatus < EnumerateIt::Base
  associate_values :pending_completion, :released, :annuled, :refused
end