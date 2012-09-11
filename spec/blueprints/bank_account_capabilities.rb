# encoding: utf-8
BankAccountCapability.blueprint(:reforma) do
  capability { Capability.make!(:reforma) }
  status { Status::ACTIVE }
  date { Date.new(2012, 1, 1) }
end
