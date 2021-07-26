class JudgmentFormsController < CrudController
  has_scope :by_kind, :allow_blank => true
end
