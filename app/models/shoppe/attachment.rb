class Shoppe::Attachment < ActiveRecord::Base
  
  # Set the table name
  self.table_name = 'shoppe_attachments'
  
  # This will be the ActionDispatch::UploadedFile object which be diseminated
  # by the class on save.
  attr_accessor :uploaded_file
  
  # Relationships
  belongs_to :parent, :polymorphic => true
  
  # Validations
  validates :file_name, :presence => true
  validates :file_type, :presence => true
  validates :data, :presence => true
  validates :token, :presence => true, :uniqueness => true
  
  # All attachments should have a token assigned to this
  before_validation { self.token = SecureRandom.uuid if self.token.blank? }
  
  # Copy values from the `uploaded_file` and set them as the appropriate
  # fields on this model
  before_validation do
    if self.uploaded_file
      self.data = self.uploaded_file.tempfile.read
      self.file_name = self.uploaded_file.original_filename
      self.file_type = self.uploaded_file.content_type
    end
  end
  
  # Return the attachment for a given role
  def self.for(role)
    self.where(:role => role).first
  end
  
  # Return the path to the attachment
  def path
    "/attachment/#{id}/#{file_name}"
  end
  
  # Is the attachment an image?
  def image?
    file_type =~ /\Aimage\//
  end
  
end
