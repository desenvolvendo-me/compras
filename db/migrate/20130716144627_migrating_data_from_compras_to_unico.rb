class MigratingDataFromComprasToUnico < ActiveRecord::Migration
  def up
    if Rails.env.development? || Rails.env.test?
      execute <<-SQL
        INSERT INTO unico_banks
            (id, name, code, acronym, created_at, updated_at)
            SELECT id, name, code, acronym, created_at, updated_at
                FROM compras_banks;
      SQL

      execute <<-SQL
        INSERT INTO unico_agencies
            (id, name, number, digit, bank_id, phone, fax, email, created_at, updated_at)
            SELECT id, name, number, digit, bank_id, phone, fax, email, created_at, updated_at
                FROM compras_agencies;
      SQL

      execute <<-SQL
        INSERT INTO unico_bank_accounts
            (id, description, agency_id, account_number, status, kind, digit, created_at, updated_at)
            SELECT id, description, agency_id, account_number, status, kind, digit, created_at, updated_at
                FROM compras_bank_accounts;
      SQL

      execute <<-SQL
        INSERT INTO unico_creditors
            (id, occupation_classification_id, municipal_public_administration, autonomous, social_identification_number, main_cnae_id, contract_start_date, person_id, created_at, updated_at, organ_responsible_for_registration, custom_data)
            SELECT id, occupation_classification_id, municipal_public_administration, autonomous, social_identification_number, main_cnae_id, contract_start_date, person_id, created_at, updated_at, organ_responsible_for_registration, custom_data
                FROM compras_creditors;
      SQL

      execute <<-SQL
        INSERT INTO unico_creditor_representatives
            (id, creditor_id, representative_person_id)
            SELECT id, creditor_id, representative_person_id
                FROM compras_creditor_representatives;
      SQL

      execute <<-SQL
        INSERT INTO unico_creditor_secondary_cnaes
            (id, creditor_id, cnae_id)
            SELECT id, creditor_id, cnae_id
                FROM compras_creditor_secondary_cnaes;
      SQL

      execute <<-SQL
        INSERT INTO unico_creditor_balances
            (id, creditor_id, fiscal_year, current_assets, long_term_assets, current_liabilities, net_equity, long_term_liabilities, liquidity_ratio_general, current_radio, net_working_capital)
            SELECT id, creditor_id, fiscal_year, current_assets, long_term_assets, current_liabilities, net_equity, long_term_liabilities, liquidity_ratio_general, current_radio, net_working_capital
                FROM compras_creditor_balances;
      SQL

      execute <<-SQL
        INSERT INTO unico_creditor_bank_accounts
            (id, creditor_id, agency_id, status, account_type, number, digit, created_at, updated_at)
            SELECT id, creditor_id, agency_id, status, account_type, number, digit, '2012-10-29 15:00', '2012-10-29 15:00'
                FROM compras_creditor_bank_accounts;
      SQL

      execute <<-SQL
        INSERT INTO unico_document_types
            (id, validity, description, habilitation_kind, created_at, updated_at)
            SELECT id, validity, description, habilitation_kind, created_at, updated_at
                FROM compras_document_types;
      SQL

      execute <<-SQL
        INSERT INTO unico_creditor_documents
            (id, creditor_id, document_type_id, document_number, emission_date, validity, issuer, created_at, updated_at)
            SELECT id, creditor_id, document_type_id, document_number, emission_date, validity, issuer, created_at, updated_at
                FROM compras_creditor_documents;
      SQL

      execute <<-SQL
        INSERT INTO unico_registration_cadastral_certificates
            (id, creditor_id, fiscal_year, number, specification, registration_date, validity_date, revocation_date, capital_stock, capital_whole, total_sales, building_area, total_area, total_employees, commercial_registry_registration_date, commercial_registry_number, created_at, updated_at)
            SELECT id, creditor_id, fiscal_year, number, specification, registration_date, validity_date, revocation_date, capital_stock, capital_whole, total_sales, building_area, total_area, total_employees, commercial_registry_registration_date, commercial_registry_number, created_at, updated_at
                FROM compras_registration_cadastral_certificates;
      SQL

      execute <<-SQL
        INSERT INTO unico_regularization_or_administrative_sanction_reasons
            (id, description, reason_type, created_at, updated_at)
            SELECT id, description, reason_type, created_at, updated_at
                FROM compras_regularization_or_administrative_sanction_reasons;
      SQL

      execute <<-SQL
        INSERT INTO unico_regularization_or_administrative_sanctions
            (id, creditor_id, regularization_or_administrative_sanction_reason_id, suspended_until, occurrence, created_at, updated_at)
            SELECT id, creditor_id, regularization_or_administrative_sanction_reason_id, suspended_until, occurrence, '2012-10-29 15:00', '2012-10-29 15:00'
                FROM compras_regularization_or_administrative_sanctions;
      SQL
    end
  end

  def down
    if Rails.env.development? || Rails.env.test?
      execute <<-SQL
        DELETE FROM unico_regularization_or_administrative_sanctions;
      SQL

      execute <<-SQL
        DELETE FROM unico_regularization_or_administrative_sanction_reasons;
      SQL

      execute <<-SQL
        DELETE FROM unico_registration_cadastral_certificates;
      SQL

      execute <<-SQL
        DELETE FROM unico_creditor_documents;
      SQL

      execute <<-SQL
        DELETE FROM unico_document_types;
      SQL

      execute <<-SQL
        DELETE FROM unico_creditor_bank_accounts;
      SQL

      execute <<-SQL
        DELETE FROM unico_creditor_balances;
      SQL

      execute <<-SQL
        DELETE FROM unico_creditor_secondary_cnaes;
      SQL

      execute <<-SQL
        DELETE FROM unico_creditor_representatives;
      SQL

      execute <<-SQL
        DELETE FROM unico_creditors;
      SQL

      execute <<-SQL
        DELETE FROM unico_bank_accounts;
      SQL

      execute <<-SQL
        DELETE FROM unico_agencies;
      SQL

      execute <<-SQL
        DELETE FROM unico_banks;
      SQL
    end
  end
end
