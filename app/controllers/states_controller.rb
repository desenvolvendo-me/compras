class StatesController < CrudController
  actions :all, :except => [:new, :create]
end
