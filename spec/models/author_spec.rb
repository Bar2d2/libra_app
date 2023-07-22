# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'model validation' do
    context 'when author has valid attributes' do
      it 'has no errors'
    end
    context 'when author without a first_name' do
      it 'got validation error'
    end
    context 'when author without a last_name' do
      it 'got validation error'
    end
    context 'when genre is selected' do
      it 'has genre selected'
    end
    context 'when genre is not selected' do
      it 'has no genre'
    end
    context 'when author has no book' do
      it 'has no book relations'
    end
    context 'when author has one book' do
      it 'has one book relation'
    end
    context 'when author has many books' do
      it 'has many book relations'
    end
  end
end
