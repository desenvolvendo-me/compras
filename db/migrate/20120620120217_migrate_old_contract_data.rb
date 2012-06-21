class MigrateOldContractData < ActiveRecord::Migration
  class Contract < Compras::Model; end
  class ServiceOrContractType < Compras::Model; end

  def change
    Contract.find_each do |contract|
      Contract.update_all({
        :sequential_number => (Contract.next_sequential(contract.year, contract.entity_id)-1),
        :service_or_contract_type_id => ServiceOrContractType.where { service_goal.eq(contract.kind) }.first.try(:id)
      }, { :id => contract.id })
    end
  end
end
