class AgreementOccurrenceKind < EnumerateIt::Base
  associate_values :in_progress,
                   :returned,
                   :terminated,
                   :completed,
                   :paralyzed,
                   :other
end
