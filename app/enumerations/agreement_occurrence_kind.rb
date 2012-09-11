class AgreementOccurrenceKind < EnumerateIt::Base
  associate_values :in_progress,
                   :returned,
                   :terminated,
                   :completed,
                   :paralyzed,
                   :other

  def self.inactive_kinds
    to_a.reject { |e| e[1] == 'in_progress' }
  end
end
