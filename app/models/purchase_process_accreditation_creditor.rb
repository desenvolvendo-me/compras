class PurchaseProcessAccreditationCreditor < Compras::Model
  attr_accessible :purchase_process_accreditation_id, :creditor_id, :company_size_id,
                  :creditor_representative_id, :kind, :has_power_of_attorney

  has_enumeration_for :kind, :with => PurchaseProcessAccreditationCreditorKind

  belongs_to :purchase_process_accreditation
  belongs_to :creditor
  belongs_to :company_size
  belongs_to :creditor_representative

  has_many :trading_item_bids, class_name: 'PurchaseProcessTradingItemBid',
    dependent: :restrict

  delegate :company?, :personable_type_humanize, :address, :city, :state, :identity_document,
           :neighborhood, :zip_code, :phone, :person_email,
           :proposal_by_item,
           :to => :creditor, :allow_nil => true, :prefix => true
  delegate :identity_document, :phone, :email, :identity_number,
           :to => :creditor_representative, :allow_nil => true, :prefix => true
  delegate :benefited?, to: :company_size, allow_nil: true

  validates :kind, :presence => true, :if => :creditor_representative_present?
  validates :creditor, :purchase_process_accreditation, :presence => true
  validates :company_size, presence: true, if: :creditor_company?

  scope :selected_creditors, lambda {
    where {
      has_power_of_attorney.eq(true)
    }
  }

  scope :by_lowest_proposal, lambda { |item_id|
    joins { creditor.purchase_process_creditor_proposals }.
    where {
      creditor.purchase_process_creditor_proposals.purchase_process_item_id.eq(item_id) &
      creditor.purchase_process_creditor_proposals.disqualified.eq(false)
    }.
    order('has_power_of_attorney DESC, compras_purchase_process_creditor_proposals.unit_price DESC')
  }

  scope :benefited, lambda {
    joins { company_size.extended_company_size }.
    where {
      company_size.extended_company_size.benefited.eq(true)
    }
  }

  scope :less_or_equal_to_trading_bid_value, lambda { |value|
    joins { trading_item_bids }.
    where { trading_item_bids.amount.lteq(value) }
  }

  def to_s
    creditor.to_s
  end

  private

  def creditor_representative_present?
    creditor_representative.present?
  end
end
