class Month < EnumerateIt::Base
  associate_values(
    :january => 1,
    :february => 2,
    :march => 3,
    :april => 4,
    :may => 5,
    :june => 6,
    :july => 7,
    :august => 8,
    :september => 9,
    :october => 10,
    :november => 11,
    :december => 12
  )

  def self.sorted_array
    enumeration.values.map { |month| [Month.t(month.first), month.first] }
  end
end
