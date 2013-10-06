class Shoppe::AttachmentsController < Shoppe::ApplicationController
  
  def destroy
    @attachment = Shoppe::Attachment.find(params[:id])
    @attachment.destroy
    redirect_to request.referer, :notice => "Attachment removed successfully"
  end
  
end
