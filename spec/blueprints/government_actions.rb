# encoding: utf-8
GovernmentAction.blueprint(:governamental) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { "Ação Governamental" }
  status { Status::ACTIVE }
end

GovernmentAction.blueprint(:nacional) do
  descriptor { Descriptor.make!(:detran_2012) }
  description { "Ação Nacional" }
  status { Status::ACTIVE }
end
