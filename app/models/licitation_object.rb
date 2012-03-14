class LicitationObject < ActiveRecord::Base
  attr_accessible :description, :year, :purchase_licitation_exemption, :purchase_invitation_letter, :purchase_taking_price
  attr_accessible :purchase_public_concurrency, :build_licitation_exemption, :build_invitation_letter, :build_taking_price
  attr_accessible :build_public_concurrency, :special_auction, :special_unenforceability, :special_contest
  attr_accessible :material_ids

  attr_modal :description, :year

  has_many :direct_purchases, :dependent => :restrict

  has_and_belongs_to_many :materials

  validates :description, :year, :purchase_licitation_exemption, :purchase_invitation_letter, :purchase_taking_price,
            :purchase_public_concurrency, :build_licitation_exemption, :build_invitation_letter, :build_taking_price,
            :build_public_concurrency, :special_auction, :special_unenforceability, :special_contest, :presence => true

  validates :description, :uniqueness => { :scope => [:year], :message => :taken_for_informed_year }

  validates :year, :mask => "9999"

  orderize :description
  filterize

  def licitation_exemption(modality)
    case modality
    when DirectPurchaseModality::MATERIAL_OR_SERVICE
      purchase_licitation_exemption
    when DirectPurchaseModality::ENGINEERING_WORKS
      build_licitation_exemption
    end
  end

  def to_s
    description
  end
end
