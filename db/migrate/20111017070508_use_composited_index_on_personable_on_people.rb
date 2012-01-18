class UseCompositedIndexOnPersonableOnPeople < ActiveRecord::Migration
  def up
    remove_index :people, :name => :index_contributors_on_personable_id
    remove_index :people, :name => :index_contributors_on_personable_type

    add_index :people, [:personable_id, :personable_type]
  end

  def down
    remove_index :people, [:personable_id, :personable_type]

    add_index :people, :personable_type, :name => :index_contributors_on_personable_type
    add_index :people, :personable_id, :name => :index_contributors_on_personable_id
  end
end
