module Api
  module Auction
    class PurchaseProcessProposalsController < Controller

      # GET /api/auction/purchase_process_proposals/:id
      def show
        purchase_process_proposal = licitation_process

        render :json => purchase_process_proposal.to_json(:include => :purchase_process_creditor_proposals)
      end

      # POST /api/auction/purchase_process_proposals/:id
      def create
        purchase_process_proposal = licitation_process


        if purchase_process_proposal.update_attributes(params[:licitation_process])
          render :json => purchase_process_proposal
        else
          render :json => {:errors => purchase_process_proposal.errors}, :status => :unprocessable_entity
        end
      end

      def update
        purchase_process_proposal = licitation_process


        if purchase_process_proposal.update_attributes(params[:licitation_process])
          render :json => purchase_process_proposal
        else
          render :json => {:errors => purchase_process_proposal.errors}, :status => :unprocessable_entity
        end
      end

      def destroy
        purchase_process_proposal = PurchaseProcessCreditorProposal.where(licitation_process_id: params[:id], creditor_id: creditor).last

        if purchase_process_proposal
          if purchase_process_proposal.destroy
            render :json => purchase_process_proposal
          else
            render :json => {:errors => purchase_process_proposal.errors}, :status => :unprocessable_entity
          end
        else
          render :json => {:errors => {purchase_process_proposal: "não encontrada"}}, :status => :not_found
        end
      end

      private

      def licitation_process
        id = params[:id].present? ? params[:id] : params[:licitation_process][:id]
        LicitationProcess.find(id)
      end

      def creditor
        Creditor.find(params[:creditor_id])
      end

    end
  end
end
