AgreementParticipant.blueprint(:sobrinho) do
  creditor { Creditor.make!(:sobrinho) }
  value { 190000.00 }
  kind { AgreementParticipantKind::CONVENENTE }
  governmental_sphere { AgreementGovernmentalSphere::STATE }
end

AgreementParticipant.blueprint(:sobrinho_granting) do
  creditor { Creditor.make!(:sobrinho) }
  value { 190000.00 }
  kind { AgreementParticipantKind::GRANTING }
  governmental_sphere { AgreementGovernmentalSphere::STATE }
end
