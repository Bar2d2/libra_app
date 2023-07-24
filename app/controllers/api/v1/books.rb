# frozen_string_literal: true

module API
  module V1
    class Books < Grape::API
      helpers Grape::Pagy::Helpers
      version 'v1', using: :path
      format :json
      prefix :api

      resource :books do
        desc 'Upload a cover image for a book'
        params do
          requires :id, type: Integer, desc: 'ID of the book to upload the cover image'
          requires :cover, type: File, desc: 'Cover image file to upload'
        end
        post ':id/upload_cover' do
          book = Book.find(params[:id])

          # Make sure you update the bucket name and folder structure according to your S3 setup
          bucket = Aws::S3::Resource.new.bucket(Rails.application.credentials.s3[:bucket])
          object = bucket.object("books/#{params[:id]}/cover/#{params[:cover][:filename]}")

          begin
            object.upload_file(params[:cover][:tempfile], acl: 'public-read', content_disposition: 'inline')
            book.update(cover: object.public_url)
            { message: 'Cover image uploaded successfully' }
          rescue StandardError => e
            error!({ error: 'Failed to upload cover image', details: e.message }, 500)
          end
        end

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
