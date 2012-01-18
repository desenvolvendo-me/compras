class Identity < ActiveRecord::Base
  attr_accessible :number, :issuer, :state_id, :issue

  attr_readonly :person_id

  belongs_to :individual
  belongs_to :state

  validates :number, :issuer, :state, :issue, :presence => true

  validates :issue, :timeliness => { :before => :today, :type => :date }

  def to_s
    number.to_s
  end
end
