class AddSummarizedObjectToAdministrativeProcess < ActiveRecord::Migration
  def change
    add_column :compras_administrative_processes, :summarized_object, :string
  end
end
