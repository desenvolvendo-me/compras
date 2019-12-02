builder resource, json do
  json.purchase_form                  resource.to_s
  json.expense                        resource.expense
  json.organ                          resource.organ
  json.unity                          resource.unity
  json.reference_expense              resource.reference_expense
  json.description_project_activity   resource.description_project_activity
  json.nature_expense                 resource.nature_expense
  json.resource_source                resource.resource_source
  json.description_resource_source    resource.description_resource_source
end