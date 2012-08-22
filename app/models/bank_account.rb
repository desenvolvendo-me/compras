class BankAccount < Compras::Model
  attr_accessible :description, :agency_id, :account_number, :status, :kind,
                  :digit, :bank, :bank_id

  attr_modal :description, :agency_id, :account_number

  attr_writer :bank, :bank_id

  has_enumeration_for :status
  has_enumeration_for :kind, :with => BankAccountKind

  belongs_to :agency

  delegate :number, :digit, :to => :agency, :allow_nil => true, :prefix => true

  validates :description, :agency, :kind, :account_number, :digit,
            :presence => true
  validates :account_number, :numericality => true
  validates :description, :uniqueness => { :scope => :agency_id },
            :allow_blank => true

  orderize :description
  filterize

  def to_s
    description
  end

  def bank
    agency.try(:bank) || @bank
  end

  def bank_id
    agency.try(:bank_id) || @bank_id
  end
end
