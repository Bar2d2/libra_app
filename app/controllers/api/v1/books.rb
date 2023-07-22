# frozen_string_literal: true

module API
  module V1
    class Books < Grape::API
      helpers Grape::Pagy::Helpers
      version 'v1', using: :path
      format :json
      prefix :api

      resource :books do
        desc 'Show all books with paginations'
        params do
          use :pagy,
              items_param: :per_page,
              items: 5,
              max_items: 10
        end

        get do
          books = Book.all
          present pagy(books)
        end

        desc 'Create a new book'
        params do
          requires :title, allow_blank: false, type: String, desc: 'Book title'
          requires :author_id, allow_blank: false, type: Integer, desc: 'ID of the book author'
          optional :data, type: Hash do
            optional :info, type: String, desc: 'Some kind of information about the book'
          end
        end

        post do
          book = Book.create(
            title: params[:title],
            author_id: params[:author_id],
            data: params[:data]
          )
          if book.persisted?
            present book, with: Entities::Book
          else
            error!({ error: 'Validation failed', details: book.errors.full_messages }, 422)
          end
        end

        route_param :id do
          desc 'Get a specific book'
          get do
            book = Book.find(params[:id])
            present book, with: Entities::Book
          end

          desc 'Update a book'
          params do
            optional :title, allow_blank: false, type: String, desc: 'Book title'
            optional :author_id, allow_blank: false, type: Integer, desc: 'ID of the book author'
            optional :data, type: Hash do
              optional :info, type: String, desc: 'Some kind of information about the book'
            end
          end
          put do
            book = Book.find(params[:id])
            book.update(
              title: params[:title],
              author_id: params[:author_id],
              data: params[:data]
            )
            { message: 'Book was updated successfully' }
            present book, with: Entities::Book
          end

          desc 'Delete a book'
          delete do
            book = Book.find(params[:id])
            book.destroy
            { message: 'Book was deleted successfully' }
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
