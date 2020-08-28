class ProcessResponsible < Compras::Model
  attr_accessible :licitation_process_id, :stage_process_id, :employee_id,
    :imported

  belongs_to :licitation_process
  belongs_to :stage_process
  belongs_to :employee

  has_many :judgment_commission_advices, through: :licitation_process
  has_many :licitation_commission_members, through: :judgment_commission_advices, order: :id

  has_one :street, through: :employee
  has_one :neighborhood, through: :employee

  delegate :year, :process, :type_of_purchase, to: :licitation_process, allow_nil: true, prefix: true
  delegate :name, to: :street, allow_nil: true, prefix: true
  delegate :name, to: :neighborhood, allow_nil: true, prefix: true
  delegate :cpf, :name, :phone, :email, :zip_code, :city, :state,
    to: :employee, allow_nil: true
  delegate :acronym, to: :state, allow_nil: true, prefix: true
  delegate :tce_mg_code, to: :city, allow_nil: true, prefix: true
  delegate :description, to: :stage_process, allow_nil: true, prefix: true

  validates :licitation_process, :stage_process, presence: true
  validate  :cant_change_stage_process, if: :imported_and_changing_stage_process?

  scope :licitation, lambda {
    joins { stage_process }.
    where { stage_process.type_of_purchase.eq(PurchaseProcessTypeOfPurchase::LICITATION) }
  }

  def destroyable?
    not_imported?
  end

  def not_imported?
    !imported?
  end

  private

  def imported_and_changing_stage_process?
    imported? && !stage_process_id_was.nil? && stage_process_id_changed?
  end

  def cant_change_stage_process
    errors.add(:stage_process, :cant_be_changed_when_is_imported)
  end
end
