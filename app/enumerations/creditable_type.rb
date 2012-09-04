class CreditableType < EnumerateIt::Base
  associate_values :person => 'Person', :special_entry => 'SpecialEntry'
end
