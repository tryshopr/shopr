module Shopr
  class AttachmentsController < Shopr::ApplicationController
    def destroy
      @attachment = Shopr::Attachment.find_by!(token: params[:id])
      @attachment.destroy
      respond_to do |wants|
        wants.html { redirect_to request.referer, notice: t('shopr.attachments.remove_notice') }
        wants.json { render status: 'complete' }
      end
    end
  end
end
