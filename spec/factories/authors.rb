# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { 'John' }
    last_name { 'Doe' }
    genre { 1 }
  end
end
