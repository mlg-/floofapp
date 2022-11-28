# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

## v1

 first_article = Article.create(title: 'This is an anxietycore news headline, get scared', body: 'nihilist despair')
  second_article = Article.create(title: 'This is a post about how cute dogs are', body: 'spoiler: really darn cute')

  Comment.create(body: 'yeah, I am pretty nervous, thanks for your help with that', author: 'MLG', article: first_article)
  Comment.create(body: 'YOLO!!!', author: 'NMG', article: first_article)
  Comment.create(body: 'wow this is aggressive, thanks i hate it', author: 'Allison Berry Esq', article: first_article)
  Comment.create(body: 'really very cute', author: 'Dory', article: second_article)


## v2
  # mlg = User.create!(email: 'bloop@shoop.com', first_name: 'Melissa Leigh', last_name: 'Gore')
  # nathan = User.create!(email: 'naterpotater@spud.co', first_name: 'Nathan', last_name: 'Goodman')
  # alli = User.create!(email: 'alli@palli.com', first_name: 'Alli', last_name: 'Berry')
  # dory = User.create!(email: 'indoorgal@tidydogs.us', first_name: 'Dory', last_name: 'Matatall')
  # hive_mind = User.create!(email: 'anbody@fear.com', first_name: 'random', last_name: 'bloop')

  # first_article = Article.create!(title: 'This is an anxietycore news headline, get scared', body: 'nihilist despair', user: hive_mind)
  # second_article = Article.create!(title: 'This is a post about how cute dogs are', body: 'spoiler: really darn cute', user: hive_mind)

  # Comment.create!(body: 'yeah, I am pretty nervous, thanks for your help with that', user: mlg, article: first_article)
  # Comment.create!(body: 'YOLO!!!', user: nathan, article: first_article)
  # Comment.create!(body: 'wow this is aggressive, thanks i hate it', user: alli, article: first_article)
  # Comment.create!(body: 'really very cute', user: dory, article: second_article)
