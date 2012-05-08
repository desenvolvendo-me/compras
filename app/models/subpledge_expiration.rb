class SubpledgeExpiration < ActiveRecord::Base
  attr_accessible :subpledge_id, :number, :value, :expiration_date

  belongs_to :subpledge
  has_many :subpledge_cancellations, :dependent => :restrict

  validates :expiration_date, :value, :presence => true
  validates :expiration_date, :timeliness => { :on_or_after => :today, :type => :date }, :on => :create

  orderize :id
  filterize

  def to_s
    number.to_s
  end

  def balance
    value - canceled_values
  end

  def canceled_values
    subpledge_cancellations.sum(:value)
  end
end
