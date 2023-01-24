# # Intro to Ruby on Rails, Session 2: Everything is a Thing(tm)
## Preface
### pre-reqs
1. some knowledge of any programming or scripting language
2. basic understanding of [how the web works](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/How_the_Web_works): HTTP request-response cycle

### goals
To offer a whirlwind, syllabus outline level tour of Ruby on Rails (with nods to the quirks of Indigo) 

### non-goals
To be exhaustive or complete, to get deep on any one topic! Please leave your weed fertilizer at home, thank you!!

### last time!
Last time we did a quick overview of the Ruby programming language and an introduction to the Ruby on Rails web framework. We talked about the MVC (model-view-controller) paradigm of web app organization, and how Rails is  an _opinionated_ framework that prefers following conventions over being infinitely customizable in an effort to make it fast to build.

## Introducing ActiveRecord!
Let’s zoom in on the “M” part of the MVC pattern in Rails by taking a close look at `ActiveRecord`.

### What is it?
ActiveRecord is a ORM that comes with Rails and is one of its most powerful native features. 

### Ok but what is an ORM tho
ORM is an acronym for a pattern called “Object Relational Mapping.” It is a design pattern that allows us to more easily retrieve and store information from the database attached to our application and combine that information with rich, intuitive, and powerful object interfaces.

ActiveRecord is a specific implementation of an ORM designed by Martin Fowler and available in various web frameworks like Django, Laravel, and Ruby on Rails. 

Imagine each row in your database is the interior pages of a book, while the class and its methods are the hardcover that wraps around it. An ORM lets you engage with the entire thing in a natural way, both its contents and persistent attributes as well as its behaviors and interfaces.

### That sounds fancy but it’s still kinda theoretical. Can you give me some concrete examples of what you mean?

Of course!

With ActiveRecord you can…

* Describe the objects in your application
* Represent relationships between those objects
* Show how objects inherit behavior from one another
* Validate objects before persisting them to the database
* Do database operations in an object-oriented way

(adapted from the Rails Guides)

[complete section by 2:10]

## Using ActiveRecord to modify the database with migrations
Remember last time we added comments to my very-rudimentary blog? Let’s go back and review how we created the migration file, added the columns we needed, and then ran the migration:

### Creating a table

```ruby
# from the command line in my rails project directory

rails generate migration adds_comments
```

```ruby
# the file Rails generates in my project in app/db/migrate

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
```

```ruby
# from the command line in my rails project directory

rails db:migrate
```


### Rolling Back

Let’s say I made a mistake in this migration before I’ve merged it in and I need to roll it back so I can modify it. I can do that using the `rails db:rollback` command from my project directory. The output will let me know if I’ve been successful:

```ruby
➜  floofapp git:(main) rails db:rollback
== 20221018180455 AddsComments: reverting =====================================
-- drop_table(:comments)
   -> 0.0020s
== 20221018180455 AddsComments: reverted (0.0042s) ============================
```

`rails db:rollback` accepts a `STEP` parameter expressed as an integer. This is the equivalent of running the command over and over the number of steps you specify. So if I ran

```ruby
rails db:rollback STEP=2
```

I’d have an empty database.

### Figuring out what migrations are in what state

ActiveRecord keeps track of what migrations have run in a special table.  You can see this table if you run `rails db:migrate:status` , with output like this…

```ruby
➜  floofapp git:(main) rails db:migrate:status

database: db/development.sqlite3

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20210628173505  Create articles
   up     20221018180455  Adds comments
```


### Going to a particular migration ID

To go forward or backwards to a particular version, use the `VERSION` option with `rails db:migrate`, combined with the migration ID, which can be found via the timestamp prefix in the filename or in the table provided by `rails db:migration`.

i.e. `rails db:migrate VERSION=20221018180455`

### Common issues & gotchas

*My test can’t find a table, but I made a migration for it. What happened?*

Rails keeps two versions of your database running locally: test and development. When you’ve finalized your migration you will need to run it against the test environment with the RAILS_ENV option: `rails db:migrate RAILS_ENV=test`, for example.

*When can I use `up` and `down` instead of `change`?*

Rails knows how to reverse [certain kinds of migrations](https://guides.rubyonrails.org/active_record_migrations.html#using-the-change-method) automatically. Always run your migration forwards and backwards locally to confirm it can be done before merging your code into `main`.

Whenever possible, migrations should be reversible. If that is truly, absolutely impossible (such as when data is deleted and not able to be recreated), call `ActiveRecord::IrreversibleMigration` in the `down` method so running a `rollback` will raise an error.

*Can I still write SQL in my migration if I can’t figure out how to do the thing I need via ActiveRecord?*

Absolutely. Use this kind of syntax, and still be sure to make your migration can roll forward and backwards without throwing an error. Let’s say we require all comments to have a zip code to enable more respectful discourse (lol). Here’s how we’d make sure all were 5 chars (inadequate for all cases but go with me here!!)

```ruby
execute <<-SQL
          ALTER TABLE comments
            ADD CONSTRAINT zipcode
              CHECK (char_length(zipcode) = 5) NO INHERIT;
SQL

```

*What’s the best way to see all the tables and columns already in the database?*
Rails keeps track of that in a `schema.sql`  file or a `structure.sql` one (Indigo has the latter). You can do a search of this file in your text editor to see things. You can also open a database console `rails dbconsole` and explore tables using native SQL commands for whatever variant of sql you have).

## Associations
When we created our models last time we briefly touched on how we use the model to associate them to one another. This is making explicit the relationship set up via foreign keys in the database.

### has_many & belongs_to
We’ve seen an example of this already last time. Our comments belong to our articles, and the articles have many comments. Here’s how that is expressed in the model:
```ruby
class Comment < ActiveRecord::Base
  belongs_to :article
  
  ...
end
```

```ruby
class Article < ActiveRecord::Base
  has_many :comments

	...
end
```

This gives us the ability to get the associated comments for any article if we’ve looked up that object with ActiveRecord, like so:
```ruby
[14] pry(main)> Article.find(1).comments
  Article Load (4.1ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Comment Load (2.6ms)  SELECT "comments".* FROM "comments" WHERE "comments"."article_id" = ?  [["article_id", 1]]
=> [#<Comment:0x00007fa391da4800
  id: 1,
  body: "yeah, I am pretty nervous, thanks for your help with that",
  author: "MLG",
  article_id: 1,
  created_at: Wed, 23 Nov 2022 22:24:02 UTC +00:00,
  updated_at: Wed, 23 Nov 2022 22:24:02 UTC +00:00>,
 #<Comment:0x00007fa391da42d8 id: 2, body: "YOLO!!!", author: "NMG", article_id: 1, created_at: Wed, 23 Nov 2022 22:24:02 UTC +00:00, updated_at: Wed, 23 Nov 2022 22:24:02 UTC +00:00>,
 #<Comment:0x00007fa3825bfd10
  id: 3,
  body: "wow this is aggressive, thanks i hate it",
  author: "Allison Berry Esq",
  article_id: 1,
  created_at: Wed, 23 Nov 2022 22:24:02 UTC +00:00,
  updated_at: Wed, 23 Nov 2022 22:24:02 UTC +00:00>]
```

More on queries to come.

### has_many, through:

Now let’s say we upgrade the concept of the author on the `Comment` model and add it to the `Article` model too.  Let’s rollback a couple steps (`rails db:rollback STEP=2`) modify the migrations accordingly first:

```ruby
class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      ...

      t.belongs_to :user
    end
  end
end

```

```ruby
class AddsComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      ...

      t.belongs_to :user
    end
  end
end

```

and then create a migration to add a users table `rails generate migration create_users`, fill it out with whatever columns we want, and then add a file in `app/models/user.rb` to finish it up:
```ruby
# from the command line in your project directory
rails generate migration create_users

# which generates this file in db/migrate/*
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
    end
  end
end

# fill it out more:

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      
      t.timestamps
    end
  end
end

# then run migrations to add it to the database schema:
rails db:migrate


# and finally, sketch it out in a new file in the app/models folder:

class User < ActiveRecord::Base
  has_many :comments
  has_many :articles
end
```

This was all setup for the fun stuff we are going to do now. Remember how we said we thought both `Article` and `Comment` would probably want to be related to a user? We can add that relationship in both places:

```ruby
class Article < ActiveRecord::Base
  ...
  belongs_to :user
	...
end

class Comment < ActiveRecord::Base
  ...
  belongs_to :user
  ...
end
```

What if we wanted a list of emails for users who commented on a particular article? For example, maybe they volunteered to pick up trash at the local park for Community Service Day and we want to send them a reminder, because this is the one blog in the world that is going to be prosocial and unfailingly constructive in the comment section!

We could add a relationship where each article not only has many `Comment`s, but also has many users:

```ruby
class Article < ActiveRecord::Base
  has_many :comments
  has_many :users, through: :comments
  belongs_to :user
end

```

But now it’s kinda confusing, right? Calling `some_article_var.user` means the author, but calling `some_article_var.users` means the people who commented on it. 

To fix that up, let’s use the `source` option!

```ruby
class Article < ActiveRecord::Base
  has_many :comments
  has_many :commenters, through: :comments, source: :user

  belongs_to :user

  ...

end

```

Now we can get all those commenters emails like we wanted: 
```ruby
Article.first.commenters
```

QUESTIONS?

BREAK!

## Validations
### Solving common problems: presence, format, length, uniqueness

Make sure data is always recorded for a particular attribute:
```ruby
validates :body, presence: true
```

Now if I try to create a comment without a `body`, Rails won’t let me save it:

```ruby
[3] pry(main)> Comment.create!(author: 'mlg')
ActiveRecord::RecordInvalid: Validation failed: Article must exist, Body can't be blank
from /Users/mlgore/.rbenv/versions/2.6.6/lib/ruby/gems/2.6.0/gems/activerecord-6.0.6/lib/active_record/validations.rb:80:in `raise_validation_error'
```

Validate a format is always used, and show a particular error message:
```ruby
validates :title, format: { with: /\A[a-zA-Z\s]+\z/, message: “only allows letters” }
```

Enforce a character limit:
```ruby
validates :author, length: { miniumum: 2, maximum: 50 }
```

Make sure a value is unique:
```ruby
validates :author, uniqueness: true
```

There are SO many ones for common problems and all are quite powerful. and customizable. Take a cruise through [this list](https://guides.rubyonrails.org/active_record_validations.html)!

### Only validate sometimes
Rails: There’s an Option for That(tm). Use `on: :create` to only run a validator when creating a record or `if: :some_method` to only run it if certain conditions are met.

### Gotchas

*Validations are run again anytime a record is updated, which means older data that doesn’t meet new standards may raise errors*

The solution to this depends on the situation. Maybe you only run the validation on create? Maybe you need to do a data backfill before you can add the validation?

*The validator you need isn’t standard in Rails, like one to check that the format of an email address matches what we roughly expect via a complicated regular expression*

You’ve spent 5 hours on rubular.com and you have the FINAL REGEX TO RULE THEM ALL. You need a custom validator. You can do a cute thing where you write one you can reuse in /any/ model with an email as an attribute!

We register a custom validator for this purpose in Indigo [like so](https://github.com/actblue/indigo/blob/1b49e2f3c5e114ed897133099da210b1d9ed466e/app/validators/email_validator.rb), and then any model can call it on a field it wants validated against this custom validator like [so](https://github.com/actblue/indigo/blob/1b49e2f3c5e114ed897133099da210b1d9ed466e/app/models/abandonment.rb#L16).


## Callbacks
### Lifecycle: create, read, update, delete
[ActiveRecord::Callbacks](https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/Callbacks.html)

### Solving common problems: send a transactional email, update some linked data

Let’s say we want to send an email to our commenter when their comment is moderated and visible.

First let’s add the concept of moderation to our comments quickly via a status:

```ruby
# from the command line in your project directory
rails generate migration adds_status_to_comments

# in the migration file that was just generated...
class AddsStatusToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :status, :string
  end
end
```

and then making some valid statuses:

```ruby
class Comment < ActiveRecord::Base
  ...
    validates :status, inclusion: { in: ['pending', 'approved', 'denied'] }
 ...
end
```

And now we can do fun things like make sure the commenter gets an email when their comment is updated to have an `approved` status!

```ruby
class Comment < ActiveRecord::Base
  ...
  after_update :email_commenter, if: :status_changed_to_approved?

  private

  def email_commenter
    CommentMailer.approval_notice(self.id).deliver_now
  end

  def status_changed_to_approved?
    saved_change_to_status? && status == 'approved'
  end
end
```

Now when I update any comment to be approved, a notification will be sent!

```ruby
[15] pry(main)> Comment.last.update(status: 'approved')
   (0.2ms)  SELECT sqlite_version(*)
  Comment Load (0.3ms)  SELECT "comments".* FROM "comments" ORDER BY "comments"."id" DESC LIMIT ?  [["LIMIT", 1]]
   (0.1ms)  begin transaction
  Article Load (0.1ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 2], ["LIMIT", 1]]
  User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 4], ["LIMIT", 1]]
  Comment Update (0.4ms)  UPDATE "comments" SET "status" = ?, "updated_at" = ? WHERE "comments"."id" = ?  [["status", "approved"], ["updated_at", "2022-11-28 22:48:36.093437"], ["id", 4]]
  Comment Load (0.1ms)  SELECT "comments".* FROM "comments" WHERE "comments"."id" = ? LIMIT ?  [["id", 4], ["LIMIT", 1]]
  User Load (0.0ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 4], ["LIMIT", 1]]
  Rendering comment_mailer/approval_notice.html.erb within layouts/mailer
  Rendered comment_mailer/approval_notice.html.erb within layouts/mailer (Duration: 0.1ms | Allocations: 8)
CommentMailer#approval_notice: processed outbound mail in 2.5ms
Delivered mail 63853ac41a171_111bb3fd1c8c32010296d6@MacBook-Pro.lan.mail (13.6ms)
Date: Mon, 28 Nov 2022 17:48:36 -0500
From: from@example.com
To: #<User:0x00007fa39495faf8>
Message-ID: <63853ac41a171_111bb3fd1c8c32010296d6@MacBook-Pro.lan.mail>
Subject: Your comment has been approved!
Mime-Version: 1.0
Content-Type: text/html;
 charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style>
      /* Email styles need to be inline */
    </style>
  </head>

  <body>
    dear Dory,
<h1>yay!</h1> your comment is visible.

xo,
mlg

  </body>
</html>

   (2.3ms)  commit transaction
=> true
```

## Querying
Rails models get a bunch of querying power by inheriting from `ActiveRecord::Base`.  Let’s check out some of the stuff we can do with /any/ model as soon as we create the file for it:

### Getting one thing

If you know the primary key of the row, you can grab it that way: `Comment.find(1)`

Or you can look for it by an attribute:
`Comment.find_by(author: ‘MLG’)`

Once you’ve got the thing, you can use any instance method defined in the model on it, and call any of its attributes to see their values:

i.e. `Article.find(1).pretty_created_at`
or `Article.find(1).body`

or save the instance to a local variable and then call any of the behavior it has or ask it about any of its attributes as needed
`article = Article.find(1)`

### Getting all the things
`Comment.all`

We only have a few comments, so this is trivial, but when you have a huge table, you can also use `find_in_batches(batch_size: 100)` to grab everything sequentially without trying to load all records into memory at once (ask me how I know this leads to tragic outcomes ;)

### Getting just one attribute of all the things
`Comment.all.pluck(:author)`

### Getting anything that matches certain conditions
(Note how you can chain together multiple `where` calls!
`Comment.where(author: 'MLG').where.not('created_at > ?', Date.yesterday)` 

You can also use `or`
`Comment.where(author: 'MLG').or(Comment.where(author: 'Allison Berry Esq'))`

You can also give `where` a string and then pass in a value to be interpolated in place of a `?`. Be very careful to send any queries using user-input (from, say, `params`) this way, because otherwise SQL injection is possible.

i.e. this way is safe and also valid syntax:
`Comment.where('author = ?', params[:author])`

but while this is valid syntax, it is not safe:
`Comment.where("author = #{params[:author]")`

### Eager loading with `includes`: here’s where associations meet queries
Sometimes we want to run a query only once to make loading up some information faster. We can use `includes` to grab any records we might need from associated tables:

i.e. instead of doing something like, where each article returned will result in another database hit to grab all of its comments:

```ruby
Article.where('created_at > ?', Date.yesterday).each do |article|
  article.comments.length
end
```

You can do something like this, where the comments are `SELECT`ed as part of the query and stored in memory at a local variable for easy reference later.

```ruby
Article.where('created_at > ?', Date.yesterday).includes(:comments).each { |article| article.comments.length }
```

It’s possible to nest queries quite deeply by associations:
`Article.where('created_at > ?', Date.yesterday).includes(comments: { replies: { upvotes } } )` 

### Seeing the SQL being executed for any ActiveRecord query:
Just call `.to_sql` on it! You can also call `.explain` to get a query plan.

### Encapsulate and share query logic: use scopes!
Let’s say I end up looking for recent articles pretty often, like I did in a few of the more recent queries. I can turn that logic into a special query method called a scope:

```ruby
scope :since_yesterday, -> { where('created_at > ?', Date.yesterday }
```

# Conclusion
TY TY VARKY OUT

## Resources
This talk largely used the following Rails Guides as a template, so do read them for even more examples and detail:
* [Active Record Basics — Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_basics.html)
* [Active Record Migrations — Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_migrations.html)
* [Active Record Associations — Ruby on Rails Guides](https://guides.rubyonrails.org/association_basics.html)
* [Active Record Validations — Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_validations.html)
* [Active Record Callbacks — Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_callbacks.html)
* [Active Record Query Interface — Ruby on Rails Guides](https://guides.rubyonrails.org/active_record_querying.html)
