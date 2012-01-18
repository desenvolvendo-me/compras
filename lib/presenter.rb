module Presenter
  def presenter
    presenter = "#{self.class.name}Presenter".constantize
    presenter.new(self)
  end
end
