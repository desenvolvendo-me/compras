class Report::ContractsController < Report::BaseController
  report_class ContractReport, :repository => ContractSearcher
  has_scope :between_days_finish, using: %i[started_at ended_at], :type => :hash

  def index
    @report = report_instance

    if params[:between_days_finish] || params[:all]

      @contracts = params[:all] ? (Contract.all):(apply_scopes(Contract))
      @linked_contracts = LinkedContract.includes(:contract).between_days_finish(params[:linked_contract][:started_at],params[:linked_contract][:ended_at]) if params[:linked_contract]
      @contract_additives = ContractAdditive.between_days_finish(params[:contract_additive][:started_at],params[:contract_additive][:ended_at]) if params[:contract_additive]

      respond_to do |format|
        format.html { render :show, layout: 'report' }
        format.xlsx do
          path = ContractsExporter.new(@contracts,@linked_contracts,@contract_additives).generate!
          send_file path, type: "application/xlsx", :filename => "contrato.xlsx"
        end
      end
    else
      redirect_to controller: controller_name, action: :new
    end
  end

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
  
  def show_report

  end
  
  def get_contract

    @contract = Contract.includes(:creditor).order('year desc').order(:contract_number).
      where(contract_report_params.except!(:contract_number,:content,:creditor_id,:status)).
      where('LOWER( content ) LIKE ?', "%#{contract_report_params[:content].downcase}%").
      where('contract_number LIKE ?', "%#{contract_report_params[:contract_number]}%")
    
    @contract = @contract.where("unico_creditors.id = ?",contract_report_params[:creditor_id]) if contract_report_params[:creditor_id]
    @contract = @contract.by_status(contract_report_params[:status]) if contract_report_params[:status]

    @contract
  end

  def contract_report_params
    @params = params.require(:contract_report).permit(
        :contract_number,:content,:year,:creditor_id,
        :publication_date,:contract_value,:start_date,
        :end_date,:status
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
    params.delete(:status) if params[:status].blank?
    params
  end

end
