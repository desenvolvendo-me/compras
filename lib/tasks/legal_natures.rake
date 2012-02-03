namespace :import do
  desc 'Import legal natures'
  task :legal_natures => :environment do
    legal_nature_importer = LegalNatureImporter.new
    legal_nature_importer.import!
  end
end
