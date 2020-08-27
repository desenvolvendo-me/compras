# frozen_string_literal: true

class RegularizationOrAdministrativeSanctionReason < Unico::RegularizationOrAdministrativeSanctionReason
  attr_accessible  :description, :reason_type

  orderize :description
  filterize

end
