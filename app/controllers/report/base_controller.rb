require 'active_relatus/controller'

class Report::BaseController < ApplicationController
  include ActiveRelatus::Controller

  before_filter :authorize_resource!

  def index
    redirect_to :controller => controller_name, :action => :new
  end

  def new
    @report = report_instance
  end

  def show
    @report = report_instance
    if @report.valid?
      render :layout => 'report'
    else
      render :new
    end
  end

  protected

  def authorized_resource!
    authorize! action_name, "report#{controller_name}"
  end
end
