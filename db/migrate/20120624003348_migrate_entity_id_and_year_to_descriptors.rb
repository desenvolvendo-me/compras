class MigrateEntityIdAndYearToDescriptors < ActiveRecord::Migration
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
