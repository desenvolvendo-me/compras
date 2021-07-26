ActiveSupport.on_load(:action_controller) do
  include Exceptions
end
