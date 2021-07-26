class ModalityLimit < Compras::Model
  attr_accessible :without_bidding, :invitation_letter, :taken_price,
    :public_competition, :work_without_bidding, :work_invitation_letter,
    :work_taken_price, :work_public_competition

  validates :without_bidding, :invitation_letter, :taken_price, :public_competition,
    :work_without_bidding, :work_invitation_letter, :work_taken_price,
    :work_public_competition, :presence => true

  orderize "id DESC"
  filterize

  def to_s
    "#{id}"
  end

  def self.current
    last
  end

  def self.current_limit_material_or_service_without_bidding
    current.try(:without_bidding) || zero
  end

  def self.current_limit_engineering_works_without_bidding
    current.try(:work_without_bidding) || zero
  end

  protected

  def self.zero
    BigDecimal(0)
  end
end
