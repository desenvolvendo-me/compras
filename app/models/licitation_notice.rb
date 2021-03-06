class LicitationNotice < Compras::Model
  attr_accessible :licitation_process_id, :number, :date, :observations

  belongs_to :licitation_process

  delegate :modality_humanize, :process_date, :year,
           :description, :to => :licitation_process, :prefix => true, :allow_nil => true

  validates :licitation_process, :date, :number, :presence => true

  orderize "id DESC"
  filterize

  def to_s
    "#{licitation_process} - #{I18n.l date}"
  end

  def next_number
    last_number.succ
  end

  def self.by_licitation_process(params = {})
    if params[:licitation_process_id].present?
      where { licitation_process_id.eq(params.fetch(:licitation_process_id)) }
    else
      all
    end
  end

  private

  def last_number
    self.class.joins { licitation_process }.
               where { |licitation_notice| licitation_notice.licitation_process.year.eq(licitation_process_year) }.
               maximum(:number).to_i
  end
end
