namespace :import do
  desc 'Import modality limits'
  task :modality_limits => :environment do
    importer = ModalityLimitImporter.new
    importer.import!
  end
end
