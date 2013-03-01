class JudgmentFormLicitationKindByObjectType
  attr_accessor :licitation_kind, :object_type

  def initialize(licitation_kind = LicitationKind, object_type = LicitationProcessObjectType)
    self.licitation_kind = licitation_kind
    self.object_type = object_type
  end

  def licitation_kind_groups
    {
      object_type.value_for(:DISPOSALS_OF_ASSETS) => [
        licitation_kind.value_for(:BEST_AUCTION_OR_OFFER)
      ],
      object_type.value_for(:CONCESSIONS_AND_PERMITS) => [
          licitation_kind.value_for(:BEST_AUCTION_OR_OFFER)
      ],
      object_type.value_for(:CALL_NOTICE) => [
          licitation_kind.value_for(:BEST_TECHNIQUE)
      ],
      object_type.value_for(:CONSTRUCTION_AND_ENGINEERING_SERVICES) => [
          licitation_kind.value_for(:LOWEST_PRICE),
          licitation_kind.value_for(:BEST_TECHNIQUE)
      ],
      object_type.value_for(:PURCHASE_AND_SERVICES) => [
          licitation_kind.value_for(:LOWEST_PRICE),
          licitation_kind.value_for(:BEST_TECHNIQUE)
      ]
    }
  end

  def valid_licitation_kind?(object_type, licitation_kind)
    licitation_kind_groups.include?(object_type) && licitation_kind_groups[object_type].include?(licitation_kind)
  end
end
