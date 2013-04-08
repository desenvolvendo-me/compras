class AddIssuerAndNumberLegalAnalysisAppraisal < ActiveRecord::Migration
  def change
    add_column :compras_legal_analysis_appraisals, :responsible_issuer, :string
    add_column :compras_legal_analysis_appraisals, :responsible_number, :string
  end
end
