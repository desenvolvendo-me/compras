class AddAuthorizationEnvelopeOpeningDateToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :authorization_envelope_opening_date, :date
    add_column :compras_licitation_processes, :authorization_envelope_opening_time, :time
    add_column :compras_licitation_processes, :closing_of_accreditation_date,       :date
    add_column :compras_licitation_processes, :closing_of_accreditation_time,       :time
  end
end
