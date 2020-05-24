# frozen_string_literal: true

class StreetType < InscriptioCursualis::StreetType
  validates_length_of :acronym, is: 3
  validates :acronym, mask: 'aaa', allow_blank: true
  validates :acronym, format: { without: /[0-9]/ }

  filterize
  orderize
  scope :by_name, ->(term) { where('name like ? ', term.to_s) }
end
