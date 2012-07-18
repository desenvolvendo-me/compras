module ProceduresHelper
  def procedures
    before do
      ActiveRecord::Base.connection.execute <<-SQL
        CREATE FUNCTION iptu(integer)
          RETURNS integer AS
        'SELECT $1;'
          LANGUAGE SQL;

        CREATE FUNCTION itbi(integer)
          RETURNS integer AS
        'SELECT $1;'
          LANGUAGE SQL;
      SQL
    end

    after do
      ActiveRecord::Base.connection.execute <<-SQL
        DROP FUNCTION iptu(integer);
        DROP FUNCTION itbi(integer);
      SQL
    end
  end
end

RSpec.configure do |config|
  config.extend ProceduresHelper
end