class StatusOfMovimentation < EnumerateIt::Base
  associate_values  :mail, :bailiff, :notice, :other, :coming, :unfounded, :partially_upheld, :returned, :laden, :observation, :note_expedient, :request, :deferred, :refused, :letter, :official
end
