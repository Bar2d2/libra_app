# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true, length: { maximum: 128 }
end
