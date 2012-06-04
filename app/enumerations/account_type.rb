class AccountType < EnumerateIt::Base
  associate_values :checking_account, :savings_account
end
