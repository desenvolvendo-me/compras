class ModalityLimit < ActiveRecord::Base
  attr_accessible :validity_beginning, :ordinance_number, :published_date
  attr_accessible :without_bidding, :invitation_letter, :taken_price
  attr_accessible :public_competition, :work_without_bidding
  attr_accessible :work_invitation_letter, :work_taken_price
  attr_accessible :work_public_competition

  validates :validity_beginning, :ordinance_number, :published_date, :presence => true
  validates :without_bidding, :invitation_letter, :taken_price, :presence => true
  validates :public_competition, :work_without_bidding, :presence => true
  validates :work_invitation_letter, :work_taken_price, :presence => true
  validates :work_public_competition, :presence => true
  validates_date :validity_beginning
  validates :ordinance_number, :uniqueness => { :allow_blank => true }
  validates :ordinance_number, :numericality => true, :allow_blank => true
  validate :check_validity_beginning_month

  orderize :published_date
  filterize

  def to_s
    ordinance_number
  end

  def self.current
    where { validity_beginning.lteq(Date.current) }.order { published_date }.last
  end

  def self.current_limit_material_or_service_without_bidding
    return 0 unless current

    current.without_bidding
  end

  def self.current_limit_engineering_works_without_bidding
    return 0 unless current

    current.work_without_bidding
  end

  protected

  def check_validity_beginning_month
    return unless validity_beginning

    month = validity_beginning.month
    errors.add(:validity_beginning, :invalid) unless (1..12).include? month
  end
end
