class ContractTermination < Compras::Model
  attr_accessible :expiry_date, :number, :reason, :termination_date, :year, :publication_date, :contract_id
  attr_accessible :dissemination_source_id, :fine_value, :compensation_value, :term_termination_file

  mount_uploader :term_termination_file, DocumentUploader

  belongs_to :contract
  belongs_to :dissemination_source

  validates :number, :year, :contract, :reason, :expiry_date, :termination_date, :publication_date, :dissemination_source, :presence => true
  validates :year, :mask => "9999", :allow_blank => true

  orderize :year, :number

  def to_s
    "#{year}/#{number}"
  end

  def self.next_number(year)
    last_number(year).succ
  end

  protected

  def self.last_number(year)
    where{ self.year.eq(year) }.maximum('number').to_i
  end
end
