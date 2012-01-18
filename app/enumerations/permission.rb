class Permission < EnumerateIt::Base
  associate_values :deny, :read, :modify, :access
end
