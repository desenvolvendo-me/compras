class PublicationCirculationType < EnumerateIt::Base
  associate_values :municipal_journal, :regional_newspaper, :state_newspaper, :national_newspaper, :union_official_daily, :state_official_daily, :city_official_daily, :public_mural, :internet
end
