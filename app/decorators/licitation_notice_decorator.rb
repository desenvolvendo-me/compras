class LicitationNoticeDecorator < Decorator
  def licitation_process_process_date
    helpers.l super if super
  end
end
