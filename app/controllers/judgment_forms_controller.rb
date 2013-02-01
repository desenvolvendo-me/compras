class JudgmentFormsController < CrudController
  actions :all, :except => [:new, :create, :destroy]
end
