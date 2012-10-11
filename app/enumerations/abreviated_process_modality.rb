class AbreviatedProcessModality < EnumerateIt::Base
  associate_values :making_cost_for_constructions_and_engineering_services,
                   :making_cost_for_purchases_and_services,
                   :invitation_for_constructions_engineering_services,
                   :invitation_for_purchases_and_services,
                   :competition_for_constructions_and_engineering_services,
                   :competition_for_purchases_and_services,
                   :presence_trading,
                   :auction,
                   :exemption_for_constructions_and_engineering_services,
                   :exemption_for_purchases_and_services,
                   :unenforceability,
                   :competition,
                   :competition_for_grants,
                   :other_modalities
end
