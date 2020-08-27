class District < InscriptioCursualis::District
  attr_accessible :name, :city_id

  orderize
  filterize
end
