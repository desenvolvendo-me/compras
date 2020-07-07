class AuctionType < EnumerateIt::Base
  associate_values :price_register, :traditional

  def self.to_a
    self.enumeration.values.map { |value| [translate(value[1]), value[0]] }
  end
end
