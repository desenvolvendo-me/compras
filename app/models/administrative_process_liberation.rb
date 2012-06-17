class AdministrativeProcessLiberation < Compras::Model
  attr_accessible :administrative_process_id, :employee_id, :date

  attr_readonly :administrative_process_id, :employee_id, :date

  belongs_to :administrative_process
  belongs_to :employee

  validates :administrative_process, :employee, :date, :presence => true

  def to_s
    "#{employee} - #{I18n.l(date)}"
  end
end
