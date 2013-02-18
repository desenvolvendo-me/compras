class DataType < EnumerateIt::Base
  associate_values :string, :text, :date, :decimal, :integer, :boolean, :select
end
