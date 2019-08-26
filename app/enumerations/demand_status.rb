class DemandStatus < EnumerateIt::Base
  associate_values :created, :sent, :received, :finished
end
