module Api
  module Auction
    class LicitationProcessesController < Controller

      # GET /api/auction/licitations
      def index
        find_and_execute do
          render :json => licitation_process
        end
      end

      # GET /api/auction/licitations/:id
      def show
        find_and_execute do
          render :json => licitation_process
        end
      end

      # PUT /api/auction/licitation_processes/:id
      def update
        find_and_execute do
          if licitation_process.update_attributes(params[:licitation_process])
            render :json => licitation_process, status: :ok
          else
            render :json => {:errors => licitation_process.errors}, :status => :unprocessable_entity
          end
        end
      end

      private

      def licitation_process
        @licitation_process ||= if params[:id].present?
                                  LicitationProcess.find(params[:id])
                                elsif params[:process].present? && params[:year].present?
                                  LicitationProcess.where(process: params[:process].to_i, year: params[:year].to_i).last
                                end
      end

      def find_and_execute
        if licitation_process
          yield
        else
          render :json => {:errors => [licitation_process: "não encontrado"]}, :status => :not_found
        end
      end
    end
  end
end
