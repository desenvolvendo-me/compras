class PurchaseProcessAccreditationCreditor < Compras::Model
  attr_accessible :purchase_process_accreditation_id, :creditor_id, :company_size_id,
                  :kind, :has_power_of_attorney

  has_enumeration_for :kind, :with => PurchaseProcessAccreditationCreditorKind

  belongs_to :purchase_process_accreditation
  belongs_to :creditor
  belongs_to :company_size

  has_many :trading_item_bids, class_name: 'PurchaseProcessTradingItemBid',
    dependent: :restrict

  delegate :personable_type_humanize, :address, :city, :state, :identity_document,
           :neighborhood, :zip_code, :phone, :person_email, :individual?, :company?,
           :proposal_by_item, :proposal_by_lot, :creditor_representative,
           :to => :creditor, :allow_nil => true, :prefix => true
  delegate :benefited?, to: :company_size, allow_nil: true
  delegate :judgment_form_item?, to: :purchase_process_accreditation, allow_nil: true

  validates :kind, :presence => true, :if => :creditor_representative_present?
  validates :creditor, :purchase_process_accreditation, :presence => true


  scope :selected_creditors, lambda {
    joins { creditor.person }.
    where {
      has_power_of_attorney.eq(true) | creditor.person.personable_type.eq('Individual')
    }
  }

  scope :by_lowest_proposal, lambda { |item_id|
    joins { creditor.purchase_process_creditor_proposals }.
    where {
      creditor.purchase_process_creditor_proposals.purchase_process_item_id.eq(item_id) &
      creditor.purchase_process_creditor_proposals.disqualified.eq(false)
    }.order('compras_purchase_process_creditor_proposals.ranking DESC')
  }

  scope :by_lowest_proposal_outer, lambda { |item_id|
    joins { creditor.purchase_process_creditor_proposals.outer }.
    where {
      (creditor.purchase_process_creditor_proposals.purchase_process_item_id.eq(item_id) &
      creditor.purchase_process_creditor_proposals.disqualified.eq(false) ) |
      creditor.purchase_process_creditor_proposals.id.eq(nil)
    }.order('compras_purchase_process_creditor_proposals.ranking DESC')
  }

  scope :by_lowest_proposal_on_lot, lambda { |licitation_process_id, lot|
    joins { creditor.purchase_process_creditor_proposals }.
    joins { purchase_process_accreditation }.
    where {
      purchase_process_accreditation.licitation_process_id.eq(licitation_process_id) &
      creditor.purchase_process_creditor_proposals.lot.eq(lot) &
      creditor.purchase_process_creditor_proposals.disqualified.eq(false) &
      creditor.purchase_process_creditor_proposals.licitation_process_id.eq(licitation_process_id)
    }.order('compras_purchase_process_creditor_proposals.ranking DESC')
  }

  scope :by_lowest_proposal_outer_on_lot, lambda { |licitation_process_id, lot|
    joins { purchase_process_accreditation }.
    joins { creditor.purchase_process_creditor_proposals }.
    where {
          purchase_process_accreditation.licitation_process_id.eq(licitation_process_id) &
      creditor.purchase_process_creditor_proposals.licitation_process_id.eq(licitation_process_id) &
      (creditor.purchase_process_creditor_proposals.lot.eq(lot) &
       creditor.purchase_process_creditor_proposals.disqualified.eq(false) &
       creditor.purchase_process_creditor_proposals.licitation_process_id.eq(licitation_process_id)
      )| creditor.purchase_process_creditor_proposals.id.eq(nil)
    }.order('compras_purchase_process_creditor_proposals.ranking DESC')
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

  scope :purchase_process_id, ->(purchase_process_id) do
    joins { purchase_process_accreditation }.
    where { purchase_process_accreditation.licitation_process_id.eq(purchase_process_id) }
  end

  def to_s
    creditor.to_s
  end

  private

  def creditor_representative_present?
    creditor.try(:creditor_representative).present?
  end
end
