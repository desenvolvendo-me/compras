class AppraisalReference < EnumerateIt::Base
  associate_values :draft, :notice, :public_session, :others
end
