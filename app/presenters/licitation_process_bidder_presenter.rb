class LicitationProcessBidderPresenter < Presenter::Proxy
  def process_date
    helpers.l object.licitation_process_process_date if object.licitation_process_process_date
  end
end
