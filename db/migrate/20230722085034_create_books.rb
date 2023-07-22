# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.jsonb :data, index: true, default: {}
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
