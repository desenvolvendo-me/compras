class PurchaseProcessBudgetAllocation < Compras::Model
  include BelongsToResource

  attr_accessible :licitation_process_id, :budget_allocation_id, :value,
                  :expense_nature_id

  attr_modal :material, :quantity, :unit_price

  belongs_to :licitation_process

  belongs_to_resource :expense_nature
  belongs_to_resource :budget_allocation

  delegate :expense_nature, :expense_nature_id, :amount, :balance,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  validates :budget_allocation_id, :value, :presence => true

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
end
