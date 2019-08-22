class DemandStatus < EnumerateIt::Base
  associate_values :sent, :received, :finished  
end
