# frozen_string_literal: true

class Address < InscriptioCursualis::Address
  attr_accessible  :addressable_id, :addressable_type, :street_id, :number, :block, :room, :complement, :neighborhood_id, :condominium_id, :land_subdivision_id, :zip_code

  orderize
  filterize

end
