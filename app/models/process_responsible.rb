class ProcessResponsible < Compras::Model
  attr_accessible :licitation_process_id, :stage_process_id, :employee_id

  belongs_to :licitation_process
  belongs_to :stage_process
  belongs_to :employee

  validates :licitation_process, :stage_process, presence: true
end
