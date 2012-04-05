namespace :import do
  desc 'Import revenue natures'
  task :revenue_natures => :environment do
    revenue_category_importer = RevenueNatureImporter.new
    revenue_category_importer.import!
  end
end
