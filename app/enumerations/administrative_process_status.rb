class AdministrativeProcessStatus < EnumerateIt::Base
  associate_values :waiting,
                   :released,
                   :annulled
end
