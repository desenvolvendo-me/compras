RSpec.configure do |config|
  config.around do |example|
    if example.metadata[:type] == :request || example.metadata[:type] == :turnip
      example.run

      ActiveRecord::Base.connection.execute("TRUNCATE #{ActiveRecord::Base.connection.tables.join(',')} RESTART IDENTITY CASCADE")
    else
      ActiveRecord::Base.transaction do
        example.run

        raise ActiveRecord::Rollback
      end
    end
  end
end
