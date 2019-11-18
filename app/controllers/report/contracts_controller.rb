class Report::ContractsController < Report::BaseController
  report_class ContractReport, :repository => ContractSearcher

  def show
    @contract = get_contract()

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_contract

    if contract_report_params[:creditor_id].nil?
      @contract = Contract.includes(:creditors).
          where(contract_report_params.except!(:contract_number,:content,:creditor_id)).
          where('content LIKE ?', "%#{contract_report_params[:content]}%").
          where('contract_number LIKE ?', "%#{contract_report_params[:contract_number]}%")
    else
      @contract = Contract.includes(:creditors).
          where(contract_report_params.except!(:contract_number,:content,:creditor_id)).
          where('content LIKE ?', "%#{contract_report_params[:content]}%").
          where('contract_number LIKE ?', "%#{contract_report_params[:contract_number]}%").
          where("unico_creditors.id = ?",contract_report_params[:creditor_id])

    end
  end

  def contract_report_params
    @params = params.require(:contract_report).permit(
        :contract_number,:content,:year,:creditor_id,
        :publication_date,:contract_value,:start_date,
        :end_date
    )
    @params[:contract_value] = @params[:contract_value].tr_s('.','').tr_s(',','.')
    normalize_attributes(@params)
  end

  def normalize_attributes(params)
    params.delete(:year) if params[:year].blank?
    params.delete(:creditor_id) if params[:creditor_id].blank?
    params.delete(:publication_date) if params[:publication_date].blank?
    params.delete(:contract_value) if params[:contract_value]=='0.00'
    params.delete(:start_date) if params[:start_date].blank?
    params.delete(:end_date) if params[:end_date].blank?
    params
  end

end
