class BudgetChangeDecreeType < EnumerateIt::Base
  associate_values(
    :extra_credit_decree => '1',
    :special_credit_decree => '2',
    :relocation_transposition_transfer_decree => '3',
    :extraordinary_credit_decree => '4',
    :decree_or_act_of_changing_capability_source => '5',
    :special_credit_reopening_decree => '6',
    :extraordinary_credit_reopening_decree => '7'
  )
end
