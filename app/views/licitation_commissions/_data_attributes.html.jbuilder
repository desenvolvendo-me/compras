builder resource, json do
  json.president_name                resource.president_name
  json.members resource.licitation_commission_members do |json, member|
    json.id                    member.id
    json.role_humanize         member.role_humanize
    json.role_nature_humanize  member.role_nature_humanize
    json.registration          member.registration
    json.individual_name       member.individual.to_s
    json.cpf                   member.individual_cpf
  end
end
