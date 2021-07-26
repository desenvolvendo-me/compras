require 'active_relatus/controller'

class Report::BaseController < ApplicationController
  include ActiveRelatus::Controller

  before_filter :authorize_resource!
  before_filter :set_pagination, only: :new
  before_filter :disable_pagination, only: :show

  def index
    redirect_to controller: controller_name, action: :new
  end

  def new
    @report = report_instance

    @report.valid? if @report.searched?
  end

  def show
    @report = report_instance
    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  protected

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 10
  end

  def set_pagination
    report_instance.paginate(page, per)
  end

  def disable_pagination
    report_instance.disable_pagination
  end

  def authorize_resource!
    logger.debug "PROFILE: controller_name report_#{controller_name}"
    authorize! action_name, "report_#{controller_name}"
  end
end
