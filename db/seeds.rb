# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  first_article = Article.create(title: 'This is an anxietycore news headline, get scared', body: 'nihilist despair')
  second_article = Article.create(title: 'This is a post about how cute dogs are', body: 'spoiler: really darn cute')

  Comment.create(body: 'yeah, I am pretty nervous, thanks for your help with that', author: 'MLG', article: first_article)
  Comment.create(body: 'YOLO!!!', author: 'NMG', article: first_article)
  Comment.create(body: 'wow this is aggressive, thanks i hate it', author: 'Allison Berry Esq', article: first_article)
  Comment.create(body: 'really very cute', author: 'Dory', article: second_article)
