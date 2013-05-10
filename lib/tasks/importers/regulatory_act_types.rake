namespace :import do
  desc 'Import regulatory_act_type'
  task :regulatory_act_types => :environment do
    importer = RegulatoryActTypeImporter.new
    importer.import!
  end
end
