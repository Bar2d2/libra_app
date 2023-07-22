# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 32 }
  validates :last_name, presence: true, length: { maximum: 32 }

  enum genre: %i[fantasy science thriller travel comics fiction novel cookbook psychology sport]
end
