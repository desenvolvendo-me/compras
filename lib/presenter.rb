module Presenter
  def presenter
    presenter = "#{self.class.name}Presenter".constantize
    presenter.new(self)
  end

  def presenter?
    "#{self.class.name}Presenter".safe_constantize
  end
end
