class LicitationProcessAppealRelated < EnumerateIt::Base
  associate_values :edital, :documentation, :proposal, :cancellation, :revogation
end
