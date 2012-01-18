# encoding: utf-8
Setting.blueprint(:default_city) do
  key   { 'default_city' }
  value { City.make!(:belo_horizonte).id }
end

Setting.blueprint(:default_currency) do
  key   { 'default_currency' }
  value { Currency.make!(:real).id }
end

Setting.blueprint(:default_interest) do
  key   { 'default_interest' }
  value { "0.5" }
end

Setting.blueprint(:default_penalty) do
  key   { 'default_penalty' }
  value { "2.0" }
end

Setting.blueprint(:rate_property_transfer) do
  key { 'rate_property_transfer' }
  value { "2.0" }
end

Setting.blueprint(:rate_property_transfer_funded) do
  key { 'rate_property_transfer_funded' }
  value { "0.5" }
end
