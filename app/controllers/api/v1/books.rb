# frozen_string_literal: true

module API
  module V1
    class Books < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :books do
        desc 'Return all Books'
        get do
          present Book.all
        end
      end

      resource
    end
  end
end
