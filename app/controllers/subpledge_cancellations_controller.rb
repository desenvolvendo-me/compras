class SubpledgeCancellationsController < CrudController

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      SubpledgeExpirationMovimentationGenerator.new(object).generate!
    end
  end
end
