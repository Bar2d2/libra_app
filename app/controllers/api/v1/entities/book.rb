# app/api/api/v1/entities/book.rb
module API
  module V1
    module Entities
      class Book < Grape::Entity
        expose :id
        expose :title
        expose :data
        expose :author_id
        expose :created_at
        expose :updated_at
      end
    end
  end
end