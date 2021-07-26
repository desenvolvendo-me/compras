class RemoveOccupationClassifications < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :compras_occupation_classifications
      execute <<-SQL
        UPDATE compras_creditors as A
        SET occupation_classification_id = C.id
        FROM compras_occupation_classifications B, unico_occupation_classifications C
        WHERE
          A.occupation_classification_id = B.id AND B.id = C.id;
      SQL

      execute <<-SQL
        DROP TABLE compras_occupation_classifications CASCADE
      SQL

      add_foreign_key :compras_creditors, :unico_occupation_classifications, :column => :occupation_classification_id
    end
  end
end
