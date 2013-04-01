class CreateLegalAnalysisAppraisals < ActiveRecord::Migration
  def change
    create_table :compras_legal_analysis_appraisals do |t|
      t.references  :licitation_process,        :null => false
      t.string      :appraisal_type,            :null => false
      t.string      :reference,                 :null => false
      t.date        :appraisal_expedition_date, :null => false
      t.integer     :responsible_id,            :null => false
      t.text        :substantiation

      t.timestamps
    end

    add_foreign_key :compras_legal_analysis_appraisals, :compras_licitation_processes, :column => :licitation_process_id
    add_foreign_key :compras_legal_analysis_appraisals, :compras_employees, :column => :responsible_id

    add_index :compras_legal_analysis_appraisals, :licitation_process_id, :name => :index_legal_analysis_appraisals_on_licitation_process_id
    add_index :compras_legal_analysis_appraisals, :responsible_id
  end
end
