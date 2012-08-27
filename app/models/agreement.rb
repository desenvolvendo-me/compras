class Agreement < Compras::Model
  attr_accessible :category, :code, :counterpart_value, :description,
                  :parcels_number, :process_date, :value,
                  :number_year, :number_year_process, :agreement_kind_id,
                  :regulatory_act_id, :agreement_file,
                  :agreement_bank_accounts_attributes

  mount_uploader :agreement_file, DocumentUploader

  has_enumeration_for :category, :with => AgreementCategory

  belongs_to :agreement_kind
  belongs_to :regulatory_act

  has_many :agreement_bank_accounts, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :agreement_bank_accounts, :allow_destroy => true

  delegate :creation_date, :publication_date, :end_date, :to => :regulatory_act,
           :allow_nil => true

  validates :code, :number, :year, :category, :agreement_kind, :value,
            :number_year, :counterpart_value, :parcels_number, :description,
            :process_number, :process_year, :number_year_process, :process_date,
            :regulatory_act, :presence => true

  orderize :description
  filterize

  def number_year=(joined)
    self.number, self.year = joined.split('/')
  end

  def number_year
    return unless number && year

    [number, year].join('/')
  end

  def number_year_process=(joined)
    self.process_number, self.process_year = joined.split('/')
  end

  def number_year_process
    return unless process_number && process_year

    [process_number, process_year].join('/')
  end

  def to_s
    description
  end
end
