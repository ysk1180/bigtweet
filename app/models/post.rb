class Post < ApplicationRecord
  validates :power, presence: true
  validates :power, length: { maximum: 90 }
end
