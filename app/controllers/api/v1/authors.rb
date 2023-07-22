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
            first_name: params[:first_name],
            last_name: params[:last_name],
            genre: params[:genre]
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
            author = Author.includes(:books).find(params[:id])
            author_data = {
              id: author.id,
              first_name: author.first_name,
              last_name: author.last_name,
              genre: author.genre,
              created_at: author.created_at,
              updated_at: author.updated_at,
              books_data: author.books.as_json(only: %i[id title genre])
            }

            present author_data
          end

          desc 'Update a author'
          params do
            optional :first_name, allow_blank: false, type: String, desc: 'First name'
            optional :last_name, allow_blank: false, type: String, desc: 'Last name'
            optional :genre, type: Integer, desc: 'Genre'
          end
          put do
            author = Author.find(params[:id])
            author.update(
              first_name: params[:first_name],
              last_name: params[:last_name],
              genre: params[:genre]
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
