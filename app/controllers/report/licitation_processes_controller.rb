class Report::LicitationProcessesController < Report::BaseController
  report_class LicitationProcessReport, :repository => LicitationProcessSearcher

  def show
    @report = report_instance
    @report.licitation_processes = get_licitation_processes()

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_date
    @process_date=[]
    
    @process_date[0] = create_date licitation_processes_report_params[:process_date_start]
    @process_date[1] = create_date licitation_processes_report_params[:process_date_end]

    @process_date[0] = create_date "01/01/#{Time.now.year-1}" if @process_date[0].nil?
    @process_date[1] = create_date "01/01/#{Time.now.year+1}"  if @process_date[1].nil?
    @process_date
  end

  def get_licitation_processes
    @process_date = get_date()
    @process_date_start =  @process_date[0]
    @process_date_end = @process_date[1]

    if licitation_processes_report_params[:creditor_id].nil?
      @licitation_processes = LicitationProcess.
          where(licitation_processes_report_params.except!(:creditor_id,:process_date_start,:process_date_end)).
            where(:process_date => @process_date_start..@process_date_end)
      
    else
      @licitation_processes = []
      get_includes.each do |table_include|
        @licitation_processes += LicitationProcess.
            includes(table_include).order('year desc').
                where(licitation_processes_report_params.except!(:creditor_id,:process_date_start,:process_date_end)).
                where("unico_creditors.id = ?",licitation_processes_report_params[:creditor_id]).
                where(:process_date => @process_date_start..@process_date_end)
      end
      @licitation_processes
    end
  end

  def create_date(date)
    if date
      Date.new(
        date.split('/')[2].to_i,
        date.split('/')[1].to_i,
        date.split('/')[0].to_i)
    end
  end

  def get_includes
    ["items_creditors","accreditation_creditors","license_creditors"]
  end

  def licitation_processes_report_params
    @params = params.require(:licitation_process_report).permit(
        :modality,:year,:process,:process_date,:process_date_start,
        :process_date_end,:creditor_id)
    normalize_attributes(@params)
  end

  def normalize_attributes(params)
    params.delete(:modality) if params[:modality].blank?
    params.delete(:year) if params[:year].blank?
    params.delete(:process) if params[:process].blank?
    params.delete(:process_date) if params[:process_date].blank?
    params.delete(:notice_availability_date) if params[:notice_availability_date].blank?
    params.delete(:creditor_id) if params[:creditor_id].blank?
    params.delete(:process_date_start) if params[:process_date_start].blank?
    params.delete(:process_date_end) if params[:process_date_end].blank?
    params
  end

end
