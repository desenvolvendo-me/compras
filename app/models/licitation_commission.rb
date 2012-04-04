class LicitationCommission < ActiveRecord::Base
  attr_accessible :commission_type, :nomination_date, :expiration_date, :exoneration_date
  attr_accessible :description, :regulatory_act_id

  attr_modal :commission_type, :nomination_date, :expiration_date, :exoneration_date

  has_enumeration_for :commission_type

  belongs_to :regulatory_act

  delegate :publication_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  validates :commission_type, :nomination_date, :expiration_date, :exoneration_date, :regulatory_act, :presence => true
  validates :expiration_date, :exoneration_date, :timeliness => { :on_or_after => :nomination_date, :type => :date }, :allow_blank => true

  orderize :id
  filterize

  def to_s
    id.to_s
  end
end