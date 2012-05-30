class StreetType < Unico::StreetType
  validates_length_of :acronym, :is => 3
  validates :acronym, :mask => 'aaa', :allow_blank => true
  validates :acronym, :format => { :without => /[0-9]/ }

  filterize
  orderize
end
