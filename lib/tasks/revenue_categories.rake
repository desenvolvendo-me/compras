namespace :import do
  desc 'Import revenue categories'
  task :revenue_categories => :environment do
    revenue_category_importer = RevenueCategoryImporter.new
    revenue_category_importer.import!
  end
end
