class ReserveFundStatus < EnumerateIt::Base
  associate_values :reserved, :annulled
end
