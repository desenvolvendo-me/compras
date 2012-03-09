LicitationObject.blueprint(:ponte) do
  description { "Ponte" }
  year { 2012 }
  purchase_licitation_exemption { "1.99" }
  purchase_invitation_letter { "2.99" }
  purchase_taking_price { "3.99" }
  purchase_public_concurrency { "4.99" }
  build_licitation_exemption { "5.99" }
  build_invitation_letter { "6.99" }
  build_taking_price { "7.99" }
  build_public_concurrency { "8.99" }
  special_auction { "9.99" }
  special_unenforceability { "10.99" }
  special_contest { "11.99" }
end

LicitationObject.blueprint(:viaduto) do
  description { "Viaduto" }
  year { 2012 }
  purchase_licitation_exemption { "1.99" }
  purchase_invitation_letter { "2.99" }
  purchase_taking_price { "3.99" }
  purchase_public_concurrency { "4.99" }
  build_licitation_exemption { "5.99" }
  build_invitation_letter { "6.99" }
  build_taking_price { "7.99" }
  build_public_concurrency { "8.99" }
  special_auction { "9.99" }
  special_unenforceability { "10.99" }
  special_contest { "11.99" }
  materials { [Material.make!(:arame_comum)] }
end
