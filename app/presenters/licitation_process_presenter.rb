class LicitationProcessPresenter < Presenter::Proxy
  def envelope_delivery_time
    helpers.l(object.envelope_delivery_time, :format => :hour) if object.envelope_delivery_time
  end

  def envelope_opening_time
    helpers.l(object.envelope_opening_time, :format => :hour) if object.envelope_opening_time
  end
end