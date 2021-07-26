module Api
  class MaterialsController < Controller
    # GET /api/materials
    def index
      materials = apply_scopes(Material).all

      render :json => materials.to_json(:include => :reference_unit)
    end

    # GET /api/materials/:id
    def show
      material = Material.find(params[:id])

      render :json => material.to_json(:include => :reference_unit)
    end
  end
end
