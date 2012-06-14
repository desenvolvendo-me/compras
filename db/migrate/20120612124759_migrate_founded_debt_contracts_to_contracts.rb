class MigrateFoundedDebtContractsToContracts < ActiveRecord::Migration
  class Contract < ActiveRecord::Base
  end

  class FoundedDebtContract < ActiveRecord::Base
  end

  def change
    Contract.update_all(:kind => :management)

    FoundedDebtContract.find_each do |founded|
      contract = Contract.create!(founded.attributes.except('id', 'created_at', 'updated_at').merge(:kind => 'founded'))

      Pledge.where(:founded_debt_contract_id => founded.id).update_all(:founded_debt_contract_id => contract.id)
    end
  end
end
