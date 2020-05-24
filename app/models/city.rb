# frozen_string_literal: true

class City < InscriptioCursualis::City
  attr_modal :name, :state_id

  orderize
  filterize

  scope :by_name_and_state, lambda { |params|
    joins(:state)
      .where('unico_cities.name like ? and unico_states.acronym = ?', "%#{params[0]}%", params[1])
  }
end
