class MigrateEntityIdAndYearToDescriptors < ActiveRecord::Migration
  class BudgetAllocation < Compras::Model; end
  class Capability < Compras::Model; end
  class ExpenseNature < Compras::Model; end
  class ExtraCredit < Compras::Model; end
  class GovernmentAction < Compras::Model; end
  class GovernmentProgram < Compras::Model; end
  class ManagementUnit < Compras::Model; end
  class PledgeHistoric < Compras::Model; end
  class Pledge < Compras::Model; end
  class ReserveFund < Compras::Model; end
  class RevenueAccounting < Compras::Model; end
  class RevenueNature < Compras::Model; end
  class Subfunction < Compras::Model; end

  def change
    [
      BudgetAllocation,
      Capability,
      ExpenseNature,
      ExtraCredit,
      GovernmentAction,
      GovernmentProgram,
      ManagementUnit,
      PledgeHistoric,
      Pledge,
      ReserveFund,
      RevenueAccounting,
      RevenueNature,
      Subfunction,
    ].each do |model|
      model.find_each do |object|
        descriptor = Descriptor.find_or_initialize_by_entity_id_and_year(object.entity_id, object.year)
        descriptor.save(:validate => false)
        object.update_column(:descriptor_id, descriptor.id)
      end
    end
  end
end
