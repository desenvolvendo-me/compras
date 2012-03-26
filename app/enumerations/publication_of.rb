class PublicationOf < EnumerateIt::Base
  associate_values :edital, :extension, :winners, :canceling, :edital_rectification, :ratification, :others
end
