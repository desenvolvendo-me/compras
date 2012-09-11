class AccountPlanSeparator < EnumerateIt::Base
  associate_values(
    :point => '.',
    :hyphen => '-',
    :slash => '/'
  )
end
