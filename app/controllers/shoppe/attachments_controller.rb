module Shoppe
  class AttachmentsController < Shoppe::ApplicationController
  
    def destroy
      @attachment = Nifty::Attachments::Attachment.find(params[:id])
      @attachment.destroy
      respond_to do |wants|
        wants.html { redirect_to request.referer, :notice => confirm_removed(:attachment) }
        wants.json { render :status => 'complete' }
      end
    end
  
  end
end
