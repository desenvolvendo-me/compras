class City < Unico::City
  attr_modal :name, :state_id

  orderize
  filterize
end
