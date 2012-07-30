class PersonKind < EnumerateIt::Base
  associate_values :individual => 'Individual', :company => 'Company', :special_entry => 'SpecialEntry'
end
