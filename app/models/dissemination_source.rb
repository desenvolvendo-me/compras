class DisseminationSource < Unico::DisseminationSource
  filterize
  orderize :description

  def destroyable?
    regulatory_acts.empty?
  end
end
