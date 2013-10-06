# == Schema Information
#
# Table name: attachments
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  parent_type :string(255)
#  token       :string(255)
#  role        :string(255)
#  file_name   :string(255)
#  file_type   :string(255)
#  data        :binary(16777215)
#  created_at  :datetime
#  updated_at  :datetime
#

class Shoppe::Attachment < ActiveRecord::Base
  
  attr_accessor :uploaded_file
  
  belongs_to :parent, :polymorphic => true
  
  validates :file_name, :presence => true
  validates :file_type, :presence => true
  validates :data, :presence => true
  validates :token, :presence => true, :uniqueness => true
  
  before_validation { self.token = SecureRandom.uuid if self.token.blank? }
  
  before_validation do
    if self.uploaded_file
      self.data = self.uploaded_file.tempfile.read
      self.file_name = self.uploaded_file.original_filename
      self.file_type = self.uploaded_file.content_type
    end
  end
  
  def self.for(role)
    self.where(:role => role).first
  end
  
  def path
    "/attachment/#{id}/#{file_name}"
  end
  
  def image?
    file_type =~ /\Aimage\//
  end
  
end
