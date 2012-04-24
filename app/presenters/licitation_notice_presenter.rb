class LicitationNoticePresenter < Presenter::Proxy
  def licitation_process_process_date
    helpers.l object.licitation_process_process_date if object.licitation_process_process_date
  end
end
