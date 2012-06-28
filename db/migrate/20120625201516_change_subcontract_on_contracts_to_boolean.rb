class ChangeSubcontractOnContractsToBoolean < ActiveRecord::Migration

  class Contract; end

  def change
    rename_column :compras_contracts, :subcontracting, :subcontracting_aux
    add_column :compras_contracts, :subcontracting, :boolean

    Contract.find_each do |contract|
      contract.update_attribute :subcontracting, contract.subcontracting_aux == "yes"
    end

    remove_column :compras_contracts, :subcontracting_aux
  end
end
