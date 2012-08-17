namespace :import do
  desc 'Import capability sources'
  task :capability_sources => :environment do
    importer = CapabilitySourceImporter.new
    importer.import!
  end
end
