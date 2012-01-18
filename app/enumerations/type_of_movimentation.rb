class TypeOfMovimentation < EnumerateIt::Base
 associate_values :cited, :embargo, :pledged, :auction, :judicial, :suspended, :final_sentence, :trial,
                  :cancelled, :withidrawal, :termination_of_suspension,
                  :reversal_of_the_cancellation, :observation, :inclusion_of_debt, :change_the_value_of_the_claim,
                  :attachment, :resource, :termination_of_proceedings, :subpoena, :continued, :letters_rogatory
end
