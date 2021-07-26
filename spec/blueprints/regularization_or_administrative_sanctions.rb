RegularizationOrAdministrativeSanction.blueprint(:sancao_administrativa) do
  regularization_or_administrative_sanction_reason { RegularizationOrAdministrativeSanctionReason.make!(:sancao_administrativa) }
  suspended_until { Date.new(2012, 04, 05) }
  occurrence { Date.new(2012, 01, 04) }
end