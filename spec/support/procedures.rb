module ProceduresHelper
  def create_procedures
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE FUNCTION iptu_2010(integer, integer)
      RETURNS INTEGER AS
      'SELECT $1 + $2'
      LANGUAGE SQL;

      CREATE FUNCTION iptu_2011(integer, integer)
      RETURNS INTEGER AS
      'SELECT $1 - $2'
      LANGUAGE SQL;

      CREATE FUNCTION one_argument(integer)
      RETURNS INTEGER AS
      'SELECT $1'
      LANGUAGE SQL;
    SQL
  end

  def drop_procedures
    ActiveRecord::Base.connection.execute <<-SQL
      DROP FUNCTION iptu_2010(integer, integer);
      DROP FUNCTION iptu_2011(integer, integer);
      DROP FUNCTION one_argument(integer);
    SQL
  end
end

RSpec.configure do |config|
  config.include ProceduresHelper
end
