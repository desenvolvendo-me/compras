class TradingsController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year
    super
  end

  def create
    if params[:commit] == "Salvar e ir para Itens/Ofertas"
      create! { trading_items_path(:trading_id => resource.id) }
    else
      super
    end
  end

  def update
    if params[:commit] == "Salvar e ir para Itens/Ofertas"
      update! { trading_items_path(:trading_id => resource.id) }
    else
      super
    end
  end

  def show
    render :layout => 'report'
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      TradingItemGenerator.generate!(object)
    end
  end
end
