# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'Lord of the Rings' }
    data { '{"some_info": "Lorem ipsum"}' }
    author { association :author }
  end
end
