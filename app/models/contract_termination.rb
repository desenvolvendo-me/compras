class ContractTermination < Compras::Model
  attr_accessible :expiry_date, :number, :reason, :termination_date, :year, :publication_date, :contract_id
  attr_accessible :dissemination_source_id, :fine_value, :compensation_value, :term_termination_file

  attr_readonly :number

  mount_uploader :term_termination_file, DocumentUploader

  has_enumeration_for :status, :with => ContractTerminationStatus

  belongs_to :contract
  belongs_to :dissemination_source

  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  validates :year, :contract,:reason, :expiry_date, :termination_date, :presence => true
  validates :publication_date, :dissemination_source, :presence => true
  validates :year, :mask => "9999", :allow_blank => true
  validates :contract_id, :uniqueness => { :allow_blank => true }

  before_create :generate_number

  orderize :year, :number

  def to_s
    "#{number}/#{year}"
  end

  def next_number
    self.class.last_number(self.year).succ
  end

  def annulled?
    annul.present?
  end

  def status
    if annulled?
      ContractTerminationStatus::INACTIVE
    else
      ContractTerminationStatus::ACTIVE
    end
  end

  protected

  def self.last_number(year)
    where{ self.year.eq(year) }.maximum('number').to_i
  end

  def generate_number
    self.number = next_number
  end
end
