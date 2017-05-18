class AddAttachmentProfpictureToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.has_attached_file :profpicture
    end
  end

  def self.down
    drop_attached_file :profiles, :profpicture
  end
end
