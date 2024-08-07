class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { maximum: 80 }
  validates :images, presence: true
  validate :check_count
  mount_uploaders :images, PostPhotoUploader

  def check_count
    limit = 10
    if images.length >= limit
      errors.add(:post, "画像は#{limit}枚まで投稿可能です")
    end
  end
end
