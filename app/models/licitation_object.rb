class LicitationObject < ActiveRecord::Base
  attr_accessible :description, :year, :material_ids

  attr_readonly :purchase_invitation_letter, :purchase_taking_price
  attr_readonly :purchase_public_concurrency, :build_invitation_letter, :build_taking_price
  attr_readonly :build_public_concurrency, :special_auction, :special_unenforceability, :special_contest

  attr_modal :description, :year

  has_many :direct_purchases, :dependent => :restrict

  has_and_belongs_to_many :materials

  validates :description, :year, :purchase_invitation_letter, :presence => true
  validates :purchase_taking_price, :special_unenforceability, :presence => true
  validates :build_invitation_letter, :special_contest, :presence => true
  validates :purchase_public_concurrency, :special_auction, :presence => true
  validates :build_taking_price, :build_public_concurrency, :presence => true
  validates :description, :uniqueness => { :scope => :year, :message => :taken_for_informed_year, :allow_blank => true }
  validates :year, :mask => "9999", :allow_blank => true

  orderize :description
  filterize

  def purchase_licitation_exemption
    licitation_exemption DirectPurchaseModality::MATERIAL_OR_SERVICE
  end

  def build_licitation_exemption
    licitation_exemption DirectPurchaseModality::ENGINEERING_WORKS
  end

  def to_s
    description
  end

  private

  def licitation_exemption(modality)
    DirectPurchaseBudgetAllocationItem.select([:quantity, :unit_price]).
      joins( :direct_purchase_budget_allocation => :direct_purchase ).
      where('direct_purchases.modality = ? AND direct_purchases.licitation_object_id = ?', modality, self.id ).
      collect(&:estimated_total_price).sum
  end
end
