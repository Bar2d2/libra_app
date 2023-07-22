# frozen_string_literal: true

# app/api/api/v1/entities/book.rb
module API
  module V1
    module Entities
      class Author < Grape::Entity
        expose :id
        expose :first_name
        expose :last_name
        expose :genre
        expose :created_at
        expose :updated_at
        # expose :book, using: Entities::Book, as: :book_data
      end
    end
  end
end
