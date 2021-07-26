class BudgetChangeLawType < EnumerateIt::Base
  associate_values(
    :extra_credit_authorization_law => '1',
    :special_credit_authorization_law => '2',
    :relocation_transposition_transfer_authorization_law => '3',
    :special_credit_authorization_law => '4',
    :capability_source_change_authorization_law => '5'
  )
end
