class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :body

      t.timestamps
    end

    Article.create(title: 'This is an anxietycore news headline, get scared', body: 'nihilist despair')
    Article.create(title: 'This is a post about how cute dogs are', body: 'spoiler: really darn cute')
  end
end
