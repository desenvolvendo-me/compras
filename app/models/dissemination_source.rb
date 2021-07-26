class DisseminationSource < Unico::DisseminationSource
  belongs_to :communication_source

  has_and_belongs_to_many :regulatory_acts, join_table: :unico_dissemination_sources_unico_regulatory_acts

  filterize
  orderize :description

  def destroyable?
    regulatory_acts.empty?
  end
end
