class SettingSerialNumberFromComprasToUnico < ActiveRecord::Migration
  def up
    if Rails.env.development? || Rails.env.test?

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_banks', 'id'), (SELECT MAX(id) FROM unico_banks));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_agencies', 'id'), (SELECT MAX(id) FROM unico_agencies));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_bank_accounts', 'id'), (SELECT MAX(id) FROM unico_bank_accounts));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_creditors', 'id'), (SELECT MAX(id) FROM unico_creditors));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_creditor_representatives', 'id'), (SELECT MAX(id) FROM unico_creditor_representatives));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_creditor_secondary_cnaes', 'id'), (SELECT MAX(id) FROM unico_creditor_secondary_cnaes));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_creditor_balances', 'id'), (SELECT MAX(id) FROM unico_creditor_balances));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_creditor_bank_accounts', 'id'), (SELECT MAX(id) FROM unico_creditor_bank_accounts));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_document_types', 'id'), (SELECT MAX(id) FROM unico_document_types));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_creditor_documents', 'id'), (SELECT MAX(id) FROM unico_creditor_documents));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_registration_cadastral_certificates', 'id'), (SELECT MAX(id) FROM unico_registration_cadastral_certificates));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_regularization_or_administrative_sanction_reasons', 'id'), (SELECT MAX(id) FROM unico_regularization_or_administrative_sanction_reasons));
      SQL

      execute <<-SQL
        SELECT pg_catalog.setval(pg_get_serial_sequence('unico_regularization_or_administrative_sanctions', 'id'), (SELECT MAX(id) FROM unico_regularization_or_administrative_sanctions));
      SQL
    end
  end
end
