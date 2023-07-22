# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'validation' do
    subject { build(:author) }

    context 'presence of the first name' do
      it { should validate_presence_of(:first_name) }
    end
    context 'first name length' do
      it { should validate_length_of(:first_name) }
    end
    context 'presence of the last name' do
      it { should validate_presence_of(:last_name) }
    end
    context 'last name length' do
      it { should validate_length_of(:last_name) }
    end
    context 'books relations' do
      it { should have_many(:books) }
    end
    context 'genre options' do
      it { should define_enum_for(:genre) }
    end
  end
end
