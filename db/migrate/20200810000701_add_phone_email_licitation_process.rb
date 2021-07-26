class AddPhoneEmailLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :phone_email, :string
  end
end
