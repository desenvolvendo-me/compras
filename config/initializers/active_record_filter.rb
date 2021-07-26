ActiveSupport.on_load(:active_record) do
  include ActiveRecord::Filter
end
