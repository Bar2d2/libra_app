# frozen_string_literal: true

class AddCoverImageUrlToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :cover_image_url, :string
  end
end
