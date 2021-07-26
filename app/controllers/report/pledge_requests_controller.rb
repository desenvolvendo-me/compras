class Report::PledgeRequestsController < Report::BaseController
  report_class PledgeRequestReport, :repository => PledgeRequestSearcher

  def show
    @pledge_request = get_pledge_request()
    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_pledge_request
    @pledge_request = PledgeRequest.includes(:purchase_process).
      includes(:contract).
        where(pledge_request_report_params.except!(:modality,:year))

    unless pledge_request_report_params[:modality].nil?
      @pledge_request = @pledge_request.where(
        purchase_process:{modality:pledge_request_report_params[:modality]} )
    end

    unless pledge_request_report_params[:year].nil?
      @pledge_request = @pledge_request.where(
          contract:{year:pledge_request_report_params[:year]} )
    end
    @pledge_request
  end

  def pledge_request_report_params
    @params = params.require(:pledge_request_report).permit(
        :emission_date,:modality,:contract_id,:year )
    normalize_attributes(@params)
  end

  def normalize_attributes(params)
    params.delete(:emission_date) if params[:emission_date].blank?
    params.delete(:modality) if params[:modality].blank?
    params.delete(:year) if params[:year].blank?
    params.delete(:contract_id) if params[:contract_id].blank?
    params
  end

end
