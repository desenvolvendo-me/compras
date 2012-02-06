class RemoveTypeOfAdministractiveActIdFromOrganograms < ActiveRecord::Migration
  def change
    remove_column :organograms, :type_of_administractive_act_id
  end
end
