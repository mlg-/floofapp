class AddsComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.string :author
      t.belongs_to :article

      t.timestamps
    end
  end
end
