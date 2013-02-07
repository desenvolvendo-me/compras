Customization.blueprint(:campo_string) do
  model { CustomizationModel::CREDITOR }
  state { State.make(:mg) }
  data  { [ CustomizationData.make(:string) ] }
end
