class SubpledgeExpirationMovimentationGenerator
  attr_accessor :object
  attr_accessor :movimentation_storage

  delegate :value, :pledge, :movimentable_subpledge_expirations, :to => :object

  def initialize(object, movimentation_storage = SubpledgeExpirationMovimentation)
    self.object = object
    self.movimentation_storage = movimentation_storage
  end

  def generate!
    value_left = value

    movimentable_subpledge_expirations.each do |expiration|
      return if value_left.zero?

      calculator = SubpledgeExpirationMovimentationCalculator.new(value_left, expiration.balance)

      create!(expiration, calculator)

      value_left -= calculator.movimented_value
    end
  end

  protected

  def create!(expiration, calculator)
    movimentation_storage.create!(
      :subpledge_expiration_id => expiration.id,
      :subpledge_expiration_modificator_id => object.id,
      :subpledge_expiration_modificator_type => object.class.name,
      :subpledge_expiration_value_was => expiration.balance,
      :subpledge_expiration_value => calculator.expiration_value,
      :value => calculator.movimented_value
    )
  end
end
