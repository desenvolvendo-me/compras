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
  validates :validity_beginning, :mask => '99/9999', :allow_blank => true
  validates :ordinance_number, :uniqueness => true
  validates :ordinance_number, :mask => '9999', :allow_blank => true

  orderize :published_date
  filterize

  def to_s
    ordinance_number
  end
end
