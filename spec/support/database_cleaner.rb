RSpec.configure do |config|
  config.before do
    DatabaseCleaner.strategy = if example.metadata[:type] == :request
                                 :truncation
                               else
                                 :transaction
                               end

    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
