# frozen_string_literal: true

module API
  module V1
    class Authors < Grape::API
      helpers Grape::Pagy::Helpers
      version 'v1', using: :path
      format :json
      prefix :api

      resource :authors do
        desc 'Show all authors with paginations'
        params do
          use :pagy,
              items_param: :per_page,
              items: 5,
              max_items: 10
        end

        get do
          authors = Author.all
          present pagy(authors)
        end

        desc 'Create a new author'
        params do
          requires :first_name, allow_blank: false, type: String, desc: 'Author first name'
          requires :last_name, allow_blank: false, type: String, desc: 'Author last name'
          optional :genre, type: Integer, desc: 'Genre select list'
        end

        post do
          author = Author.create(
            title: params[:title],
            author_id: params[:author_id],
            data: params[:data]
          )
          if author.persisted?
            present author, with: Entities::Author
          else
            error!({ error: 'Validation failed', details: author.errors.full_messages }, 422)
          end
        end

        route_param :id do
          desc 'Get a specific author'
          get do
            author = Author.find(params[:id])
            present author, with: Entities::Author
          end

          desc 'Update a author'
          params do
            optional :title, allow_blank: false, type: String, desc: 'Author title'
            optional :author_id, allow_blank: false, type: Integer, desc: 'ID of the author author'
            optional :data, type: Hash do
              optional :info, type: String, desc: 'Some kind of information about the author'
            end
          end
          put do
            author = Author.find(params[:id])
            author.update(
              title: params[:title],
              author_id: params[:author_id],
              data: params[:data]
            )
            present author, with: Entities::Author
          end

          desc 'Delete a author'
          delete do
            author = Author.find(params[:id])
            author.destroy
            { message: 'Author was deleted successfully' }
          end
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ error: 'Record not found', details: e.message }, 404)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ error: 'Validation errors', details: e.full_messages }, 422)
      end

      resource
    end
  end
end
