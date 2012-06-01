class RenamePledgeParcelMovimentationsPledgeParcelModificatorToPledgeParcelModifiable < ActiveRecord::Migration
  def change
    change_table :pledge_parcel_movimentations do |t|
      t.rename :pledge_parcel_modificator_id, :pledge_parcel_modifiable_id
      t.rename :pledge_parcel_modificator_type, :pledge_parcel_modifiable_type
    end
  end
end
