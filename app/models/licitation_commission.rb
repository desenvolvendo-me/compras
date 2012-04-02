class LicitationCommission < ActiveRecord::Base
  attr_accessible :commission_type, :nomination_date, :expiration_date, :exoneration_date, :description

  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  has_enumeration_for :commission_type

  validates :commission_type, :nomination_date, :expiration_date, :exoneration_date, :presence => true
  validates :expiration_date, :exoneration_date, :timeliness => { :on_or_after => :nomination_date, :type => :date }

  orderize :id
  filterize

  def to_s
    id.to_s
  end
end
