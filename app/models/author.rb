# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books

  enum genre: %i[fantasy science thriller travel comics fiction novel cookbook psychology sport]
end
