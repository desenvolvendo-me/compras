namespace :import do
  desc 'Import revenue sources'
  task :revenue_sources => :environment do
    revenue_source_importer = RevenueSourceImporter.new
    revenue_source_importer.import!
  end
end
