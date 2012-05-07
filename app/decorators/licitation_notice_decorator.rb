class LicitationNoticeDecorator < Decorator
  def licitation_process_process_date
    helpers.l component.licitation_process_process_date if component.licitation_process_process_date
  end
end
