namespace :import do
  desc 'Import revenue nature related models'
  task :revenue_natures => :environment do
    [
      RevenueCategoryImporter,
      RevenueSubcategoryImporter,
      RevenueSourceImporter,
      RevenueRubricImporter,
      RevenueNatureImporter,
    ].each do |revenue_importer|
      importer = revenue_importer.new
      importer.import!
    end
  end
end
