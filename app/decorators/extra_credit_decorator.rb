# encoding: utf-8
class ExtraCreditDecorator < Decorator
  def publication_date
    helpers.l component.publication_date if component.publication_date
  end
end
