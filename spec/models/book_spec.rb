# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'model validation' do
    context 'when book has valid attributes' do
      it 'has no errors'
    end
    context 'when book without a title' do
      it 'got validation error'
    end
    context 'when book has title with less or eqal 128 chars' do
      it 'has no errors'
    end
    context 'when book has title with more than 128 chars' do
      it 'got validation error'
    end
    context 'when book has no data' do
      it 'got empty output'
    end
    context 'when book has data' do
      it 'got jsonb output'
    end
    context 'when book has cover image' do
      it 'got file url'
    end
    context 'when book has no cover image' do
      it 'got empty file url'
    end
    context 'when book has no author' do
      it 'got validation error'
    end
    context 'when book has one author' do
      it 'got proper record relations'
    end
    context 'when book has many authors' do
      it 'got validation error'
    end
  end
end
