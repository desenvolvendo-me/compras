class SupplyAuthorizationsController < CrudController
  actions :all, :except => [:update, :destroy]
end
