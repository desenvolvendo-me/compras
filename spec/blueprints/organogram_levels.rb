# encoding: utf-8
OrganogramLevel.blueprint(:orgao) do
  description { 'Orgão' }
  level { 1 }
  digits { 2 }
  organogram_separator { OrganogramSeparator::POINT }
end

OrganogramLevel.blueprint(:unidade) do
  description { 'Unidade' }
  level { 2 }
  digits { 2 }
  organogram_separator { OrganogramSeparator::POINT }
end
