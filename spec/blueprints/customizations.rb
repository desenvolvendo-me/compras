Customization.blueprint(:campo_string) do
  model { CustomizationModel::CREDITOR }
  state { ::FactoryGirl::Preload.factories['State'][:mg] }
  data  { [ CustomizationData.make(:string) ] }
end
