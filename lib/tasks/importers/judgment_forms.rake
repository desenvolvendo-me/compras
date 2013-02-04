namespace :import do
  desc 'Import judgment forms'
  task :judgment_forms => :environment do
    importer = JudgmentFormImporter.new
    importer.import!
  end
end
