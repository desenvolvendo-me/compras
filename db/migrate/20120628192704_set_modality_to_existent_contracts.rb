class SetModalityToExistentContracts < ActiveRecord::Migration
  class Contract < Compras::Model; end

  def change
    Contract.find_each do |contract|
      modality = contract.direct_purchase_id ? 'direct_purchase' : 'licitation_process'

      contract.update_attribute :modality, modality
    end
  end
end
