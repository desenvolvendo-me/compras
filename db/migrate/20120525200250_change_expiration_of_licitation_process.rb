class ChangeExpirationOfLicitationProcess < ActiveRecord::Migration
  def change
    remove_column :licitation_processes, :expiration

    add_column :licitation_processes, :expiration, :integer
    add_column :licitation_processes, :expiration_unit, :string
  end
end
