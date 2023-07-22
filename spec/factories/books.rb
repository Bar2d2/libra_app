# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'MyString' }
    data { '' }
    author { nil }
  end
end
