class ActiveRecord::Base
  cattr_accessor :shared_connection, :instance_reader => false, :instance_writer => false

  def self.connection
    shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
