class RemoveEnvelopeDeliveryDatetimeAndEnvelopeOpeningDatetimeFromLicitationProcessImpugnment < ActiveRecord::Migration
  def change
    remove_column :licitation_process_impugnments, :envelope_delivery_date
    remove_column :licitation_process_impugnments, :envelope_delivery_time
    remove_column :licitation_process_impugnments, :envelope_opening_date
    remove_column :licitation_process_impugnments, :envelope_opening_time
  end
end
