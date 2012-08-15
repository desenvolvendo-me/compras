class RecordPriceSituation < EnumerateIt::Base
  associate_values :active, :canceled, :extended
end
