class Word < ApplicationRecord
  validates :name, presence: true
  validates :explain, presence: true
  validates :sound, presence: true
  scope :ordered, -> { order(updated_at: :desc) }

  broadcasts_to ->(word) { "words" }, inserts_by: :prepend
end
