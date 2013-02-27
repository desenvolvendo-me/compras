class LicitationNotice < Compras::Model
  attr_accessible :licitation_process_id, :number, :date, :observations

  belongs_to :licitation_process

  delegate :modality_humanize, :licitation_number, :process_date, :year,
           :description, :to => :licitation_process, :prefix => true, :allow_nil => true

  validates :licitation_process, :date, :number, :presence => true

  orderize "id DESC"
  filterize

  def to_s
    id.to_s
  end

  def next_number
    last_number.succ
  end

  private

  def last_number
    self.class.joins { licitation_process }.
               where { |licitation_notice| licitation_notice.licitation_process.year.eq(licitation_process_year) }.
               maximum(:number).to_i
  end
end
