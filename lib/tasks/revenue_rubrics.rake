namespace :import do
  desc 'Import revenue rubrics'
  task :revenue_rubrics => :environment do
    importer = RevenueRubricImporter.new
    importer.import!
  end
end
