class ReserveFund < Compras::Model
  attr_accessible :descriptor_id, :budget_allocation_id, :licitation_process_id
  attr_accessible :value, :reserve_allocation_type_id, :reserve_allocation_type_id
  attr_accessible :licitation_modality_id, :creditor_id, :status, :date, :reason

  attr_readonly :date

  attr_modal :date, :licitation_modality_id, :creditor_id, :status,
             :descriptor_id, :budget_allocation_id, :reserve_allocation_type_id

  has_enumeration_for :status, :with => ReserveFundStatus, :create_helpers => true

  belongs_to :licitation_process
  belongs_to :descriptor
  belongs_to :budget_allocation
  belongs_to :reserve_allocation_type
  belongs_to :licitation_modality
  belongs_to :creditor

  has_many :pledges, :dependent => :restrict

  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  delegate :real_amount, :amount, :function, :subfunction, :government_program, :government_action, :budget_structure,
           :expense_nature, :reserved_value, :to => :budget_allocation, :allow_nil => true, :prefix => true
  delegate :licitation?, :to => :reserve_allocation_type, :allow_nil => true
  delegate :expense_category_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_group_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_modality_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_element_id, :to => :budget_allocation, :allow_nil => true
  delegate :expense_nature_expense_nature, :to => :budget_allocation, :allow_nil => true
  delegate :year, :to => :descriptor, :allow_nil => true
  delegate :administrative_process, :to => :licitation_process, :allow_nil => true

  validates :descriptor, :budget_allocation, :value, :reserve_allocation_type, :date, :presence => true
  validate :value_should_not_exceed_available_reserve

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :date, :timeliness => {
      :on_or_after => lambda { last.date },
      :on_or_after_message => :must_be_greater_or_equal_to_last_date,
      :type => :date,
      :if => :any_reserve_fund?
    }
  end

  before_save :clear_licitation_dependent_field_if_is_not_licitation

  orderize :id
  filterize

  def to_s
    "#{id}/#{year}"
  end

  def annul!
    update_column :status, ReserveFundStatus::ANNULLED
  end

  protected

  def value_should_not_exceed_available_reserve(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless budget_allocation

    available_reserve = budget_allocation_amount - budget_allocation_reserved_value

    if value > available_reserve
      errors.add(:value, :should_not_exceed_reserved_value, :value => numeric_parser.localize(available_reserve))
    end
  end

  def clear_licitation_dependent_field_if_is_not_licitation
    unless licitation?
      self.licitation_modality_id = nil
      self.licitation_process = nil
    end
  end

  def any_reserve_fund?
    self.class.any?
  end
end
