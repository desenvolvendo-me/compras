ActiveSupport.on_load(:active_record) do
  include Decore::Infection
end
