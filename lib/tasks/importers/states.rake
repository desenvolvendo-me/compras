namespace :import do
  desc 'Import states'
  task :states => :environment do
    state_importer = StateImporter.new
    state_importer.import!
  end
end
