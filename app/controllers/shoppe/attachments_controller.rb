class Shoppe::AttachmentsController < Shoppe::ApplicationController
  
  def show
    image = Shoppe::Attachment.find(params[:id])
    send_data image.data, :type => image.file_type, :filename => image.file_name, :disposition => 'inline'
  end
  
  def destroy
    @attachment = Shoppe::Attachment.find(params[:id])
    @attachment.destroy
    respond_to do |wants|
      wants.html { redirect_to request.referer, :notice => "Attachment removed successfully" }
      wants.json { render :status => 'complete' }
    end
  end
  
end
