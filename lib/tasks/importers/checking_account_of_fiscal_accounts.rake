namespace :import do
  desc 'Import checking_account_of_fiscal_accounts'
  task :checking_account_of_fiscal_accounts => :environment do
    importer = CheckingAccountOfFiscalAccountImporter.new
    importer.import!
  end
end
