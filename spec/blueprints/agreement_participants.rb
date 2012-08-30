AgreementParticipant.blueprint(:sobrinho) do
  creditor { Creditor.make!(:sobrinho) }
  value { 100.00 }
  kind { AgreementParticipantKind::CONVENENTE }
  governmental_sphere { AgreementGovernmentalSphere::STATE }
end
