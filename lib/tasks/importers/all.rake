require 'importer_helper'

namespace :import do
  desc 'Import all needed data'
  task :all => :environment do
    ImporterHelper.run do
      puts "cnaes"
      CnaeImporter.new.import! if Cnae.count.zero?

      puts "Forma de Julgamento de Licitação"
      JudgmentForm.pg_copy_from Rails.root.join('lib/import/files/judgment_forms.csv').to_s unless JudgmentForm.any?

      puts "classes de materias"
      MaterialClassImporter.new.import! if MaterialClass.count.zero?

      puts "limite por modalidade"
      ModalityLimitImporter.new.import! if ModalityLimit.count.zero?

      puts "Etapas do Processo"
      StageProcess.pg_copy_from Rails.root.join('lib/import/files/stage_processes.csv').to_s unless StageProcess.any?

      puts "importações realizadas com sucesso."
    end
  end
end
