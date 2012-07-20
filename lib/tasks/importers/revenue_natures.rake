def revenue_importers
  [
    RevenueCategoryImporter,
    RevenueSubcategoryImporter,
    RevenueSourceImporter,
    RevenueRubricImporter,
    RevenueNatureImporter,
  ]
end

namespace :import do
  desc 'Import revenue nature related models'
  task :revenue_natures => :environment do
    ActiveRecord::Base.transaction do
      importers.each do |revenue_importer|
        importer = revenue_importer.new
        importer.import!
      end
    end
  end
end
