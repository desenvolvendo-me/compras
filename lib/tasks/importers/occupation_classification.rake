namespace :import do
  desc 'Import occupation classifications'
  task :occupation_classifications => :environment do
    oc_importer = OccupationClassificationImporter.new
    oc_importer.import!
  end
end
