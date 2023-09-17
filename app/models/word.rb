class Word < ApplicationRecord
  validates :name, presence: true
end
