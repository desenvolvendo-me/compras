module TceExport::MG
  module Formatters
    class ExpenseClassificationFormatter
      def initialize(entity_code, budget_allocation, expense_nature)
        @entity_code = entity_code
        @budget_allocation = budget_allocation
        @expense_nature = expense_nature
      end

      def to_s
        format
      end

      private

      attr_reader :entity_code, :budget_allocation, :expense_nature

      def format
        [
          unit_code,
          function_code,
          subfunction_code,
          government_program_code,
          government_action_type,
          government_action_code,
          expense_nature_code
        ].join
      end

      def unit_code
        unit = budget_allocation.budget_structure_structure_sequence[1]

        if unit.nil?
          raise TceExport::MG::Exceptions::InvalidData, "Código da estrutura orçamentária inválido"
        end

        [entity_code.to_s.rjust(2, "0"), unit.code.to_s.rjust(3, "0")].join
      end

      def function_code
        budget_allocation.function_code.to_s.rjust(2, "0")
      end

      def subfunction_code
        budget_allocation.subfunction_code.to_s.rjust(3, "0")
      end

      def government_program_code
        budget_allocation.government_program_code.to_s.rjust(4, "0")
      end

      def government_action_type
        budget_allocation.government_action_action_type.to_s
      end

      def government_action_code
        budget_allocation.government_action_code[1..3]
      end

      def expense_nature_code
        expense_nature.expense_nature.gsub(/\D/, "")
      end
    end
  end
end
