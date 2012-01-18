class StatusOfTransfer < EnumerateIt::Base
  associate_values :open, :calculated, :canceled, :transfered
end
