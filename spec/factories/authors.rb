# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { 'MyString' }
    last_name { 'MyString' }
    genre { 1 }
  end
end
