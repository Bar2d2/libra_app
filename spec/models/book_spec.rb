# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validation' do
    subject { build(:book) }

    context 'presence of the title' do
      it { should validate_presence_of(:title) }
    end
    context 'title length' do
      it { should validate_length_of(:title) }
    end
    context 'relations to author' do
      it { should belong_to(:author) }
    end
  end
end
