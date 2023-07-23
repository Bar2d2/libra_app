# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::Books', type: :request do
  def json_response
    JSON.parse(response.body)
  end

  describe 'GET /api/v1/books' do
    let!(:books) { create_list(:book, 5) }

    before { get '/api/v1/books' }

    it 'returns a list of books' do
      expect(response).to have_http_status(200)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(5)
    end
  end

  describe 'POST /api/v1/books' do
    let(:author) { create(:author) }
    let(:valid_attributes) { { title: 'Sample Book', author_id: author.id, data: {} } }

    context 'with valid attributes' do
      it 'creates a new book' do
        expect do
          post '/api/v1/books', params: valid_attributes
        end.to change(Book, :count).by(1)

        expect(response).to have_http_status(201)
        expect(json_response).to include('id', 'title', 'data', 'author_id', 'created_at', 'updated_at')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new book' do
        expect do
          post '/api/v1/books', params: { title: 'Sample Book', author_id: nil }
        end.not_to change(Book, :count)

        expect(response).to have_http_status(422)
        expect(json_response).to include('error')
      end
    end
  end

  describe 'GET /api/v1/books/:id' do
    let!(:book) { create(:book) }

    before { get "/api/v1/books/#{book.id}" }

    it 'returns a specific book' do
      expect(response).to have_http_status(200)
      expect(json_response).to include('id', 'title', 'data', 'author_id', 'created_at', 'updated_at')
    end
  end

  describe 'PUT /api/v1/books/:id' do
    let!(:book) { create(:book) }

    context 'with valid attributes' do
      it 'updates the book' do
        put "/api/v1/books/#{book.id}", params: { title: 'Updated Book' }

        expect(response).to have_http_status(200)
        expect(json_response['title']).to eq('Updated Book')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the book' do
        put "/api/v1/books/#{book.id}", params: { title: '' }

        expect(response).to have_http_status(422)
        expect(json_response).to include('error')
      end
    end
  end

  describe 'DELETE /api/v1/books/:id' do
    let!(:book) { create(:book) }

    it 'deletes the book' do
      expect do
        delete "/api/v1/books/#{book.id}"
      end.to change(Book, :count).by(-1)

      expect(response).to have_http_status(200)
      expect(json_response).to include('message')
    end
  end

  describe 'POST /api/v1/books/:id/upload_cover_image' do
    let!(:book) { create(:book) }

    context 'with valid parameters' do
      let(:file_path) { Rails.root.join('spec', 'fixtures', 'book_cover.jpg') }

      it 'uploads the cover image and returns the cover_image_url' do
        file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')
        post "/api/v1/books/#{book.id}/upload_cover_image", params: { cover_image: file }

        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include('message' => 'Cover image uploaded successfully')

        book.reload
        expect(book.cover_image_url).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'returns a validation error if no file is attached' do
        post "/api/v1/books/#{book.id}/upload_cover_image", params: {}

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to include('error' => 'Validation errors')
      end

      it 'returns an error if the book ID does not exist' do
        file_path = Rails.root.join('spec', 'fixtures', 'book_cover.jpg')
        file = Rack::Test::UploadedFile.new(file_path, 'image/jpeg')
        post "/api/v1/books/#{book.id + 100}/upload_cover_image", params: { cover_image: file }

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to include('error' => 'Record not found')
      end
    end
  end
end
