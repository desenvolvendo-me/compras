namespace :import do
  desc 'Import pledge historics'
  task :pledge_historics => :environment do
    importer = PledgeHistoricImporter.new
    importer.import!
  end
end
