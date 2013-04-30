class PurchaseProcessAccreditationCreditor < Compras::Model
  attr_accessible :purchase_process_accreditation_id, :creditor_id, :company_size_id,
                  :creditor_representative_id, :kind, :has_power_of_attorney

  has_enumeration_for :kind, :with => PurchaseProcessAccreditationCreditorKind

  belongs_to :purchase_process_accreditation
  belongs_to :creditor
  belongs_to :company_size
  belongs_to :creditor_representative

  delegate :company?, :personable_type_humanize, :address, :city, :state, :identity_document,
           :neighborhood, :zip_code, :phone, :person_email,
           :to => :creditor, :allow_nil => true, :prefix => true
  delegate :identity_document, :phone, :email, :identity_number,
           :to => :creditor_representative, :allow_nil => true, :prefix => true

  validates :kind, :presence => true, :if => :creditor_representative_present?
  validates :creditor, :purchase_process_accreditation, :presence => true
  validates :company_size, presence: true, if: :creditor_company?

  private

  def creditor_representative_present?
    creditor_representative.present?
  end
end
