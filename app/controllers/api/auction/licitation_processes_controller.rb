module Api
  module Auction
    class LicitationProcessesController < Controller

      # GET /api/auction/licitations
      def index
        find
      end

      # GET /api/auction/licitations/:id
      def show
        find
      end

      private

      def licitation_process
        if params[:id].present?
          LicitationProcess.find(params[:id])
        elsif params[:process].present? && params[:year].present?
          LicitationProcess.where(process: params[:process].to_i, year: params[:year].to_i).last
        end
      end

      def find
        if licitation_process
          render :json => licitation_process
        else
          render :json => {:errors => [licitation_process: "não encontrado"]}, :status => :not_found
        end
      end

    end
  end
end
