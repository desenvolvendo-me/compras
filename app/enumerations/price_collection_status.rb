class PriceCollectionStatus < EnumerateIt::Base
  associate_values :active, :annulled
end
