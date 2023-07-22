# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::Authors', type: :request do
  def json_response
    JSON.parse(response.body)
  end

  describe 'GET /api/v1/authors' do
    let!(:authors) { create_list(:author, 5) }

    before { get '/api/v1/authors' }

    it 'returns a list of authors' do
      expect(response).to have_http_status(200)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(5)
    end
  end

  describe 'POST /api/v1/authors' do
    let(:author) { create(:author) }
    let(:valid_attributes) { { first_name: 'John', last_name: 'Doe', genre: 1 } }

    context 'with valid attributes' do
      it 'creates a new author' do
        expect do
          post '/api/v1/authors', params: valid_attributes
        end.to change(Author, :count).by(1)

        expect(response).to have_http_status(201)
        expect(json_response).to include('id', 'first_name', 'last_name', 'genre', 'created_at', 'updated_at')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new author' do
        expect do
          post '/api/v1/authors', params: { first_name: 'John', last_name: nil }
        end.not_to change(Author, :count)

        expect(response).to have_http_status(422)
        expect(json_response).to include('error')
      end
    end
  end

  describe 'GET /api/v1/authors/:id' do
    let!(:author) { create(:author) }

    before { get "/api/v1/authors/#{author.id}" }

    it 'returns a specific author' do
      expect(response).to have_http_status(200)
      expect(json_response).to include('id', 'first_name', 'last_name', 'genre', 'created_at', 'updated_at')
    end
  end

  describe 'PUT /api/v1/authors/:id' do
    let!(:author) { create(:author) }

    context 'with valid attributes' do
      it 'updates the author' do
        put "/api/v1/authors/#{author.id}", params: { genre: 4 }

        expect(response).to have_http_status(200)
        expect(json_response['genre']).to eq('comics')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the author' do
        put "/api/v1/authors/#{author.id}", params: { first_name: '' }

        expect(response).to have_http_status(422)
        expect(json_response).to include('error')
      end
    end
  end

  describe 'DELETE /api/v1/authors/:id' do
    let!(:author) { create(:author) }

    it 'deletes the author' do
      expect do
        delete "/api/v1/authors/#{author.id}"
      end.to change(Author, :count).by(-1)

      expect(response).to have_http_status(200)
      expect(json_response).to include('message')
    end
  end
end
