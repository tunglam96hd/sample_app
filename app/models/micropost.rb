class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.User.content.maximum}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.micropost.sizefile.megabytes
    errors.add :picture, t("less_5mb")
  end
end
