module CustomDataQuery
  extend CustomData

  custom_data.each do |key|
    attr_accessible key

    define_method(key) do
      custom_data && custom_data[key]
    end

    define_method("{key}=") do |value|
      self.custom_data = (custom_data || {}).merge(key => value)
    end
  end
end
