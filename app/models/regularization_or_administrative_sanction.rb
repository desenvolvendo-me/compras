class RegularizationOrAdministrativeSanction < ActiveRecord::Base
  attr_accessible :creditor_id, :suspended_until, :occurrence
  attr_accessible :regularization_or_administrative_sanction_reason_id

  belongs_to :creditor
  belongs_to :regularization_or_administrative_sanction_reason

  delegate :administrative_sanction?, :regularization?, :description, :reason_type_humanize,
    :to => :regularization_or_administrative_sanction_reason, :allow_nil => true

  validates :creditor, :occurrence, :presence => true
  validates :regularization_or_administrative_sanction_reason, :presence => true
  validates :suspended_until, :presence => true, :if => :administrative_sanction?
  validates :suspended_until, :occurrence,
    :timeliness => {:type => :date },
    :allow_blank => true
end
