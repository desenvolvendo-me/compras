class Status < EnumerateIt::Base
  associate_values :active, :inactive
end
