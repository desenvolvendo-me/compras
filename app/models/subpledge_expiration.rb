class SubpledgeExpiration < ActiveRecord::Base
  attr_accessible :subpledge_id, :number, :value, :expiration_date

  belongs_to :subpledge

  has_many :subpledge_expiration_movimentations, :dependent => :restrict

  validates :expiration_date, :value, :presence => true
  validates :expiration_date, :timeliness => { :on_or_after => :today, :type => :date }, :on => :create

  orderize :id
  filterize

  def to_s
    number.to_s
  end

  def balance
    value - canceled_value
  end

  def canceled_value
    subpledge_expiration_movimentations.where { subpledge_expiration_modificator_type.eq 'SubpledgeCancellation' }.sum(:value)
  end
end
