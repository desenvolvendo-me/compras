class LicitationCommission < ActiveRecord::Base
  attr_accessible :commission_type, :nomination_date, :expiration_date, :exoneration_date, :description

  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  has_enumeration_for :commission_type

  validates :commission_type, :nomination_date, :expiration_date, :exoneration_date, :presence => true

  orderize :id
  filterize

  def to_s
    id.to_s
  end
end
