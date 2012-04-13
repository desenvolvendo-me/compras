class AddNewEnvelopeDeveliryDatetimeAndNewEnvelopeOpeningDatetimeToLicitationProcessImpugnment < ActiveRecord::Migration
  def change
    add_column :licitation_process_impugnments, :new_envelope_delivery_date, :date

    add_column :licitation_process_impugnments, :new_envelope_delivery_time, :time

    add_column :licitation_process_impugnments, :new_envelope_opening_date, :date

    add_column :licitation_process_impugnments, :new_envelope_opening_time, :time

  end
end
