class State < InscriptioCursualis::State
  attr_modal :name

  has_many :account_plan_configurations, :dependent => :restrict

  filterize
  orderize

  def self.id_by_acronym!(acronym)
    find_by_acronym!(acronym).id
  end
end
