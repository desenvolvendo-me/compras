class PurchaseProcessBudgetAllocation < Compras::Model
  include BelongsToResource

  attr_accessible :licitation_process_id, :budget_allocation_id, :value,
                  :expense_nature_id

  attr_modal :material, :quantity, :unit_price

  belongs_to :licitation_process

  belongs_to_resource :expense_nature
  belongs_to_resource :budget_allocation

  delegate :expense_nature, :expense_nature_id, :amount, :balance, :descriptor_id,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  validates :budget_allocation_id, :value, :presence => true

  validate :validate_budget_allocation, on: :update,
    if: :budget_allocation_id_changed?

  before_destroy :block_when_budget_allocation_used

  private

  def budget_allocation_params
    {
      includes: [
        :expense_nature,
        {
          budget_structure: { except: :custom_data },
          budget_allocation_capabilities: { include: {
            capability: {
              only: :id,
              methods: [
                :capability_source_code
              ]
            },
            budget_allocation: {
              include: {
                budget_structure: {
                  methods: [
                    :structure_sequence
                  ]
                }
              },
              methods: [
                :expense_nature_expense_nature,
                :function_code,
                :subfunction_code,
                :government_program_code,
                :government_action_code,
                :government_action_action_type,
                :amount
              ]
            }
          }}
        }
      ],
      methods: [
        :balance,
        :amount,
        :budget_structure_structure_sequence,
      ]
    }
  end

  def validate_budget_allocation
    return unless old_budget_allocation_id.present?

    budget_allocation_old = BudgetAllocation.find old_budget_allocation_id

    if !budget_allocation_old.can_be_used?(licitation_process)
      errors.add :budget_allocation, :already_reserved_or_pledged
    end
  end

  def block_when_budget_allocation_used
    if budget_allocation_id && !budget_allocation(false).can_be_used?(licitation_process)
      errors.add :budget_allocation, :already_reserved_or_pledged
    end

    errors.blank?
  end
end
