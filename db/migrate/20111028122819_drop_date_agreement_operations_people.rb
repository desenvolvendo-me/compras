class DropDateAgreementOperationsPeople < ActiveRecord::Migration
  def change
    drop_table :agreement_operations_people
  end
end
