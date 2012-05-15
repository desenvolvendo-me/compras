#encoding: utf-8

SpecialEntry.blueprint(:especial) do
  address   { Address.make(:apto, :addressable => object) }
end
