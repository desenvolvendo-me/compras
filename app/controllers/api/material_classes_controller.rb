module Api
  class MaterialClassesController < Controller
    # GET /api/material_classes
    def index
      material_classes = apply_scopes(MaterialClass).all

      render :json => material_classes
    end

    # GET /api/material_classe/:id
    def show
      material_class = MaterialClass.find(params[:id])

      render :json => material_class
    end
  end
end
