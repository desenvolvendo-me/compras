class State < InscriptioCursualis::State
  attr_modal :name

  filterize
  orderize

  scope :by_name, order(:name)

  def self.id_by_acronym!(acronym)
    find_by_acronym!(acronym).id
  end
end
