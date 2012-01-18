class RemoveRealTributeValueFromAgreementOperations < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :real_tribute_value
  end
end
