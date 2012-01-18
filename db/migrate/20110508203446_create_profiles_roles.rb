class CreateProfilesRoles < ActiveRecord::Migration
  def change
    create_table :profiles_roles, :id => false do |t|
      t.references :profile
      t.references :role
    end

    add_foreign_key :profiles_roles, :profiles
    add_foreign_key :profiles_roles, :roles
  end
end
