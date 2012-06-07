class AddNewDatetimeEnvelopeOpeningDateToLicitationProcessAppeals < ActiveRecord::Migration
  def change
    add_column :licitation_process_appeals, :new_envelope_opening_date, :date
    add_column :licitation_process_appeals, :new_envelope_opening_time, :time
  end
end
