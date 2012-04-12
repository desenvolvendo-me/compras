class AddEnvelopeDeveliryDatetimeAndEnvelopeOpeningDatetimeToLicitationProcessImpugnment < ActiveRecord::Migration
  def change
    add_column :licitation_process_impugnments, :envelope_delivery_date, :date

    add_column :licitation_process_impugnments, :envelope_delivery_time, :time

    add_column :licitation_process_impugnments, :envelope_opening_date, :date

    add_column :licitation_process_impugnments, :envelope_opening_time, :time

  end
end
