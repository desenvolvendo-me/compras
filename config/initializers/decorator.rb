ActiveSupport.on_load(:active_record) do
  include Decorator::Infection
end
