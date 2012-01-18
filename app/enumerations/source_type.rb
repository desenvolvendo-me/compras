class SourceType < EnumerateIt::Base
  associate_values :fiscal_notification => 'FiscalNotification', :fiscal_action => 'FiscalAction', :infraction_notice => 'InfractionNotice'
end
