class RemoveColumnAgreementOperationsMotiveId < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :motive_id
  end
end
