class City < InscriptioCursualis::City
  attr_modal :name, :state_id

  orderize
  filterize
end
