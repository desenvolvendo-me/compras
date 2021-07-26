class Report::MapOfPricesController < Report::BaseController
  report_class MapOfPriceReport, :repository => MapOfPriceSearcher

  def show
    @report = report_instance
    @report.price_collection_id = params[:id]

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end
