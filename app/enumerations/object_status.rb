class ObjectStatus < EnumerateIt::Base
  associate_values :solicited, :quoted, :licitation_in_progress, :licitation_homologated,
                   :formalized_contract, :validated_contract, :contract_released
end
