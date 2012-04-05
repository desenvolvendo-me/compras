namespace :import do
  desc 'Import revenue subcategories'
  task :revenue_subcategories => :environment do
    revenue_category_importer = RevenueSubcategoryImporter.new
    revenue_category_importer.import!
  end
end
