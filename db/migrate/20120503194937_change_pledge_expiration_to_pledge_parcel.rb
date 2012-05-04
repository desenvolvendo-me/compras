class ChangePledgeExpirationToPledgeParcel < ActiveRecord::Migration
  def up
    rename_table :pledge_expirations, :pledge_parcels

    rename_index :pledge_parcels, :index_pledge_expirations_on_pledge_id, :index_pledge_parcels_on_pledge_id
    remove_foreign_key :pledge_parcels, :name => :pledge_expirations_pledge_id_fk
    add_foreign_key :pledge_parcels, :pledges

    # pledge_cancellations
    rename_index :pledge_cancellations, :index_pledge_cancellations_on_pledge_expiration_id, :index_pledge_cancellations_on_pledge_parcel_id
    rename_column :pledge_cancellations, :pledge_expiration_id, :pledge_parcel_id
    remove_foreign_key :pledge_cancellations, :name => :pledge_cancellations_pledge_expiration_id_fk
    add_foreign_key :pledge_cancellations, :pledge_parcels

    # pledge_liquidations
    rename_index :pledge_liquidations, :index_pledge_liquidations_on_pledge_expiration_id, :index_pledge_liquidations_on_pledge_parcel_id
    rename_column :pledge_liquidations, :pledge_expiration_id, :pledge_parcel_id
    remove_foreign_key :pledge_liquidations, :name => :pledge_liquidations_pledge_expiration_id_fk
    add_foreign_key :pledge_liquidations, :pledge_parcels

    # pledge_liquidation_cancellations
    rename_index :pledge_liquidation_cancellations, :index_pledge_liquidation_cancellations_on_pledge_expiration_id, :index_pledge_liquidation_cancellations_on_pledge_parcel_id
    rename_column :pledge_liquidation_cancellations, :pledge_expiration_id, :pledge_parcel_id
    remove_foreign_key :pledge_liquidation_cancellations, :name => :pledge_liquidation_cancellations_pledge_expiration_id_fk
    add_foreign_key :pledge_liquidation_cancellations, :pledge_parcels
  end

  def down
    rename_table :pledge_parcels, :pledge_expirations

    rename_index :pledge_expirations, :index_pledge_parcels_on_pledge_id, :index_pledge_expirations_on_pledge_id
    remove_foreign_key :pledge_expirations, :name => :pledge_parcels_pledge_id_fk
    add_foreign_key :pledge_expirations, :pledges

    # pledge_cancellations
    rename_index :pledge_cancellations, :index_pledge_cancellations_on_pledge_parcel_id, :index_pledge_cancellations_on_pledge_expiration_id
    rename_column :pledge_cancellations, :pledge_parcel_id, :pledge_expiration_id
    remove_foreign_key :pledge_cancellations, :name => :pledge_cancellations_pledge_parcel_id_fk
    add_foreign_key :pledge_cancellations, :pledge_expirations

    # pledge_liquidations
    rename_index :pledge_liquidations, :index_pledge_liquidations_on_pledge_parcel_id, :index_pledge_liquidations_on_pledge_expiration_id
    rename_column :pledge_liquidations, :pledge_parcel_id, :pledge_expiration_id
    remove_foreign_key :pledge_liquidations, :name => :pledge_liquidations_pledge_parcel_id_fk
    add_foreign_key :pledge_liquidations, :pledge_expirations

    # pledge_liquidation_cancellations
    rename_index :pledge_liquidation_cancellations, :index_pledge_liquidation_cancellations_on_pledge_parcel_id, :index_pledge_liquidation_cancellations_on_pledge_expiration_id
    rename_column :pledge_liquidation_cancellations, :pledge_parcel_id, :pledge_expiration_id
    remove_foreign_key :pledge_liquidation_cancellations, :name => :pledge_liquidation_cancellations_pledge_parcel_id_fk
    add_foreign_key :pledge_liquidation_cancellations, :pledge_expirations
  end
end
