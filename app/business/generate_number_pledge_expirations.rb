class GenerateNumberPledgeExpirations
  attr_accessor :pledge_expirations

  def initialize(pledge_expirations)
    self.pledge_expirations = pledge_expirations
  end

  def generate!
    pledge_expirations.each_with_index do |expiration, index|
      expiration.number = index.succ
    end
  end
end
