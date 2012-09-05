class AgreementOccurrenceKind < EnumerateIt::Base
  associate_values :in_progress,
                   :returned,
                   :terminated,
                   :completed,
                   :paralyzed,
                   :other

  def self.inactive_kinds
    to_a.select do |item|
      [PARALYZED,  RETURNED, COMPLETED, OTHER, TERMINATED].include?(item[1])
    end
  end
end
