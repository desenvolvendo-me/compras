module TceExport::MG
  module Formatters
    class BudgetStructureCodeFormatter
      UNIT_AND_SUBUNIT_CODE_SIZE = 3

      def initialize(entity_code, budget_structure)
        @entity_code = entity_code
        @budget_structure = budget_structure
      end

      def to_s
        return "" unless budget_structure

        format
      end

      private

      attr_reader :entity_code, :budget_structure, :unit_and_subunit

      def format
        extract_unit_and_subunit
        check_unit_presence
        extract_codes
        concatenate_entity_code
      end

      def extract_unit_and_subunit
        @unit_and_subunit = budget_structure.structure_sequence[1..2]
      end

      def check_unit_presence
        unless has_unit?
          raise TceExport::MG::Exceptions::InvalidData, "Estrutura orçamentária \"#{budget_structure.to_s}\" inválida. Deve ter 2 (99.999) ou 3 níveis (99.999.999)"
        end
      end

      def has_unit?
        !unit_and_subunit.nil? && !unit_and_subunit.empty?
      end

      def extract_codes
        unit_and_subunit.map! { |unit| unit.code.to_s.rjust(UNIT_AND_SUBUNIT_CODE_SIZE, "0") }
      end

      def concatenate_entity_code
        unit_and_subunit.unshift(entity_code).join
      end
    end
  end
end
