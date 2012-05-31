class AuthenticableType < EnumerateIt::Base
  associate_values :employee => 'Employee', :provider => 'Provider'
end