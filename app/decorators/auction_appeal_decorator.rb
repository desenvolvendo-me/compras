class AuctionAppealDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :auction, :person, :appeal_date, :new_envelope_opening_date,
              :new_envelope_opening_time, :situation

  def new_envelope_opening_time
    super.strftime('%H:%M') if super
  end

  def opening_time
    super.strftime('%H:%M') if super
  end

  def closure_time
    super.strftime('%H:%M') if super
  end

  def opening_date
    I18n.l super if super
  end

  def closure_date
    I18n.l super if super
  end
end
