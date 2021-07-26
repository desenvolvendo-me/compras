class Origin < EnumerateIt::Base
  associate_values(
    :financial_surplus => '1',
    :credit_operation => '2',
    :excessive_tax_revenue => '3',
    :allocation_cancellation => '4'
  )
end
