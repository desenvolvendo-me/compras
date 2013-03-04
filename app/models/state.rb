class State < InscriptioCursualis::State
  attr_modal :name

  filterize
  orderize

  def self.id_by_acronym!(acronym)
    find_by_acronym!(acronym).id
  end
end
