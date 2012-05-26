class RemoveSocialIdentificationNumberOfCreditors < ActiveRecord::Migration
  def change
    remove_column :creditors, :social_identification_number_date
  end
end
