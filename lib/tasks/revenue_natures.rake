namespace :import do
  desc 'Import revenue natures'
  task :revenue_natures => :environment do
    importer = RevenueNatureImporter.new
    importer.import!
  end
end
