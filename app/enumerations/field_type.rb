class FieldType < EnumerateIt::Base
  associate_values :integer, :decimal, :text, :date, :datetime, :collection, :boolean
end
