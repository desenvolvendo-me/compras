Partner.blueprint(:wenderson) do
  person { Person.make!(:wenderson) }
  percentage { 100.00 }
end

Partner.blueprint(:sobrinho) do
  person { Person.make!(:sobrinho) }
  percentage { 100.00 }
end
