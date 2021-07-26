class PublicationOf < EnumerateIt::Base
  associate_values :edital, :extension, :winners, :canceling, :edital_rectification, :ratification, :others, :confirmation

  def self.allowed_for_direct_purchase
    to_a.
      sort { |a,b| a[0] <=> b[0] }.
      reject { |item| item[1] == EDITAL }
  end
end
