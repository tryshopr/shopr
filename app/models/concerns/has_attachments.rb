module HasAttachments
  
  # This concern allows you to attach files to any object in the database.
  # It still needs some work but the basics are in place.
  
  # TODO: support validation of attachments
  # TODO: handle errors?
  
  def self.included(base)
    base.extend ClassMethods
    base.has_many :attachments, :as => :parent, :dependent => :destroy
    base.before_save do
      if @pending_attachments
        @pending_attachments.each do |pa|
          old_attachments = self.attachments.where(:role => pa[:role]).pluck(:id)
          self.attachments.create(:uploaded_file => pa[:file], :role => pa[:role])
          self.attachments.where(:id => old_attachments).destroy_all
        end
        @pending_attachments = nil
      end
    end
  end
  
  module ClassMethods
    
    def attachment(name)
      has_one name, -> { select(:id, :parent_id, :parent_type, :file_name, :file_type).where(:role => name) }, :class_name => 'Attachment', :as => :parent
      
      define_method "#{name}_file" do
        instance_variable_get("@#{name}_file")
      end
      
      define_method "#{name}_file=" do |file|
        instance_variable_set("@#{name}_file", file)
        if file.is_a?(ActionDispatch::Http::UploadedFile)
          @pending_attachments ||= []
          @pending_attachments << {:role => name, :file => file}
        else
          nil
        end
      end
    end
  end
  
end
