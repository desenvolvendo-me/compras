# encoding: utf-8
require 'importer_helper'

namespace :import do
  desc 'Import all needed data'
  task :all => :environment do
    ImporterHelper.run do
      puts "cnaes"
      CnaeImporter.new.import! if Cnae.count.zero?

      puts "company_size"
      CompanySizeImporter.new.import! if CompanySize.count.zero?

      puts "Forma de Julgamento de Licitação"
      JudgmentForm.pg_copy_from Rails.root.join('lib/import/files/judgment_forms.csv').to_s unless JudgmentForm.any?

      puts "classes de materias"
      MaterialsClassImporter.new.import! if MaterialsClass.count.zero?

      puts "limite por modalidade"
      ModalityLimitImporter.new.import! if ModalityLimit.count.zero?

      puts "tipos de movimento"
      MovimentTypeImporter.new.import! if MovimentType.count.zero?

      puts "Etapas do Processo"
      StageProcess.pg_copy_from Rails.root.join('lib/import/files/stage_processes.csv').to_s unless StageProcess.any?

      puts "importações realizadas com sucesso."
    end
  end
end
