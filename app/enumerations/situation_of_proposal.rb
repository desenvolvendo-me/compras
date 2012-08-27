class SituationOfProposal < EnumerateIt::Base

  associate_values :undefined, :lost, :won, :classified, :disqualified, :not_budgeted, :tie, :canceled, :equalized

end
