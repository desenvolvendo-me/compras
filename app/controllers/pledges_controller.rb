class PledgesController < CrudController
  actions :all, :except => [:update, :destroy]
end
