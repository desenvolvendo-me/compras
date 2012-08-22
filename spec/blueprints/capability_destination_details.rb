# encoding: utf-8
CapabilityDestinationDetail.blueprint(:educacao) do
  status { CapabilityDestinationDetailStatus::ACTIVE }
  capability_allocation_detail { CapabilityAllocationDetail.make!(:educacao) }
end
