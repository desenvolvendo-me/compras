# encoding: utf-8
class ExtraCreditDecorator < Decorator
  def publication_date
    helpers.l super if super
  end
end
