# frozen_string_literal: true

require 'faker'

def generate_author
  @author = Author.create(first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name, genre: Random.rand(9))
end

def generate_books(amount, _author)
  amount.times do
    Book.create(title: Faker::Book.title, data: { "info": 'somekindofinfo' }, author: @author)
  end
end

50.times do
  generate_author
  generate_books(Random.rand(5), @author)
end
