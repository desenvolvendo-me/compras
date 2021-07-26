class AuthenticableType < EnumerateIt::Base
  associate_values :employee => 'Employee', :creditor => 'Creditor', :provider => 'Provider'
  #TODO remove provider after load migration.
end
