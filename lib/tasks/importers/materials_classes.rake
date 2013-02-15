namespace :import do
  desc 'Import materials classes'
  task :materials_classes => :environment do
    importer = MaterialsClassImporter.new
    importer.import!
  end
end
