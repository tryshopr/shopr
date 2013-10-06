module Shoppe::ShoppeHelper

  def status_tag(status)
    content_tag :span, status, :class => "status-tag #{status}"
  end
  
  def attachment_preview(attachment)
    if attachment
      String.new.tap do |s|
        if attachment.image?
          style = "style='background-image:url(#{attachment.path})'"
        else
          style = ''
        end
        s << "<div class='attachmentPreview #{attachment.image? ? 'image' : 'doc'}'>"
        s << "<div class='imgContainer'><div class='img' #{style}></div></div>"
        s << "<div class='desc'>"
        s << "<span class='filename'><a href='#{attachment.path}'>#{attachment.file_name}</a></span>"
        s << "<span class='delete'>"
        s << link_to("Delete this file?", shoppe_attachment_path(attachment), :method => :delete, :data => {:confirm => "Are you sure you wish to remove this attachment?"})
        s << "</span>"
        s << "</div>"
        s << "</div>"
      end.html_safe
    end
  end
  
end