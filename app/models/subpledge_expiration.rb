class SubpledgeExpiration < ActiveRecord::Base
  attr_accessible :subpledge_id, :number, :value, :expiration_date

  belongs_to :subpledge

  validates :expiration_date, :value, :presence => true
  validates :expiration_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create }

  def to_s
    number.to_s
  end
end
