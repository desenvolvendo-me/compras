class LicitationNotice < ActiveRecord::Base
  attr_accessible :licitation_process_id, :number, :date, :observations

  belongs_to :licitation_process

  delegate :administrative_process_modality_humanize, :licitation_number, :process_date, :year,
           :object_description, :to => :licitation_process, :prefix => true, :allow_nil => true

  validates :licitation_process_id, :date, :number, :presence => true

  orderize :id
  filterize

  def to_s
    id.to_s
  end

  def next_number
    next_number = self.class.joins { licitation_process }.
                             where { |licitation_notice| licitation_notice.licitation_process.year.eq(licitation_process_year) }.
                             maximum(:number).to_i
    next_number.succ
  end
end
