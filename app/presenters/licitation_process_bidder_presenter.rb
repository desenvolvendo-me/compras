class LicitationProcessBidderPresenter < Presenter::Proxy
  def modality_is_invited?
    licitation_process_administrative_process.is_invite?
  end

  def process_date
    helpers.l object.licitation_process_process_date if object.licitation_process_process_date
  end

  private

  def licitation_process_administrative_process
    object.licitation_process.administrative_process
  end
end
