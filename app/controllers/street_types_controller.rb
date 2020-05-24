# frozen_string_literal: true

class StreetTypesController < CrudController
  def index
    if params[:by_name]
      @types = StreetType.by_name(params[:by_name])
      render json: @types
    else
      super
    end
    end
end
