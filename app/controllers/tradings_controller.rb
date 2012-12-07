class TradingsController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year
    super
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      TradingItemGenerator.generate!(object)
    end
  end
end
