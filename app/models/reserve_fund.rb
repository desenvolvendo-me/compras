class ReserveFund < Accounting::Model
  attr_modal :date, :modality, :creditor_id, :status,
             :budget_allocation_id, :reserve_allocation_type_id

  has_enumeration_for :status, :with => ReserveFundStatus, :create_helpers => true

  belongs_to :descriptor
  belongs_to :budget_allocation
  belongs_to :reserve_allocation_type
  belongs_to :creditor

  has_many :pledges, :dependent => :restrict

  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  delegate :balance, :amount, :function, :subfunction, :government_program,
           :government_action, :budget_structure, :expense_nature,
           :expense_nature_id, :reserved_value, :to => :budget_allocation,
           :allow_nil => true, :prefix => true
  delegate :licitation?, :to => :reserve_allocation_type, :allow_nil => true
  delegate :expense_nature_expense_nature, :to => :budget_allocation, :allow_nil => true
  delegate :year, :to => :descriptor, :allow_nil => true

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

  scope :by_year, lambda { |year|
    joins { budget_allocation }.
    where { |reserve_fund| reserve_fund.budget_allocation.year.eq(year) }
  }

  def to_s
    "#{id}/#{year}"
  end

  def self.with_pledges
    joins(:pledges)
  end

  def annul!
    update_column :status, ReserveFundStatus::ANNULLED
  end

  protected

  def amount_should_not_exceed_available_reserve(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless budget_allocation

    if amount > budget_allocation_balance
      errors.add(
        :amount,
        :should_not_exceed_reserved_value,
        :amount => numeric_parser.localize(budget_allocation_balance)
      )
    end
  end

  def clear_licitation_dependent_field_if_is_not_licitation
    unless licitation?
      self.modality = nil
      self.licitation_process = nil
    end
  end

  def any_reserve_fund?
    self.class.any?
  end
end
