class DeliveryWay < EnumerateIt::Base
  associate_values :mail, :in_the_hands, :notice
end
