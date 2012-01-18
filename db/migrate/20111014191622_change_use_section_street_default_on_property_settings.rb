class ChangeUseSectionStreetDefaultOnPropertySettings < ActiveRecord::Migration
  def up
    change_column_default :property_settings, :use_section_street, false
  end

  def down
    change_column_default :property_settings, :use_section_street, nil
  end
end
