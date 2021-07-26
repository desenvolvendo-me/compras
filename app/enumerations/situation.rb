class Situation < EnumerateIt::Base
  associate_values :deferred, :refused, :pending
end