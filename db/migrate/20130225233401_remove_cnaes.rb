class RemoveCnaes < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :compras_cnaes
      Cnae.pg_copy_from Rails.root.join('lib/import/files/cnaes.csv').to_s

      execute <<-SQL
        UPDATE compras_creditors as A
        SET main_cnae_id = c.id
        FROM compras_cnaes B, unico_cnaes C
        WHERE
          A.main_cnae_id = B.id AND B.code = C.code;
      SQL

      execute <<-SQL
        UPDATE compras_creditor_secondary_cnaes as A
        SET cnae_id = c.id
        FROM compras_cnaes B, unico_cnaes C
        WHERE
          A.cnae_id = B.id AND B.code = C.code;
      SQL

      execute <<-SQL
        DROP TABLE compras_cnaes CASCADE
      SQL

      add_foreign_key :compras_creditors, :unico_cnaes, :name => :creditors_main_cnae_id_fk, :column => :main_cnae_id
      add_foreign_key :compras_creditor_secondary_cnaes, :unico_cnaes, :name => :creditor_secondary_cnaes_cnae_id_fk, :column => :cnae_id
    end
  end
end
