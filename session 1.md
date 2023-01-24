# Intro to Ruby on Rails, Session 1: Foundations
## Preface
### pre-reqs
1. some knowledge of any programming or scripting language
2. basic understanding of [how the web works](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/How_the_Web_works): HTTP request-response cycle

### goals
To offer a whirlwind, syllabus outline level tour of Ruby on Rails (with nods to the quirks of Indigo) 

### non-goals
To be exhaustive or complete, to get deep on any one topic! Please leave your weed fertilizer at home, thank you!!

## Ruby!
Created by Yukihiro “Matz” Matsumoto in the 90s, picked up steam in 2000s especially when the web framework, ruby on rails arrived
### characteristics 
1. interpreted  at runtime (not compiled)
This means ruby is subject to runtime exceptions that can be caused by unexpected interactions. Some programmers get really cranky about this, others find it freeing and faster to write.
2. dynamically typed (sometimes described as “duck typing,” where the methods an object responds to are more important than the type of object that it is aka “if it looks like a duck and it quacks like a duck, it is a duck”
3. everything in ruby is an object, which means there are a lot of shared interfaces: we can ask many different kinds of objects with varying behavior many of the same questions. everything 

### Demo!
#### Variable assignment
All variables are assigned with `=` and no keyword, i.e.:
```
my_cute_var = 'sparkles'
```

#### Strings
```
hi_i_am_a_string = "woohoo look at me go, also here's a number for funsies 5"
```

#### Integers & Math
```
irb(main):030:0> 5 + 5
=> 10
```

#### Comparison!
Some common comparison operators: `==`, `!=`, `>`, `<` 
i.e.
```
irb(main):002:0> 'bloop' == 'bloop'
=> true
irb(main):003:0> five = 5
=> 5
irb(main):004:0> seven = 7
=> 7
irb(main):006:0> five > seven
=> false
irb(main):007:0> five == seven
=> false
irb(main):008:0> five != seven
=> true
```

#### Basic data structures
##### Hashes
Hashes are unordered, key-value pairs:
```
a_hash = {}

# this also works
a_hash = Hash.new

# or get fancy 💅🏼
a_hash_with_auto_values = Hash.new(0)
a_hash_with_auto_values[:count] += 1

# the result
irb(main):017:0> a_hash_with_auto_values
=> {:count=>1}

# querying hashes
irb(main):023:0> a_hash_with_auto_values[:count]
=> 1
```

##### Arrays
Arrays are ordered lists:
```
an_array = []

# or like this
an_array = Array.new

# you can shovel (<<) things into them, cute
an_array << 'some dirt'
an_array << 'a couple rocks'

# the result:
irb(main):022:0> an_array
=> ["some dirt", "a couple rocks"]

querying arrays:
irb(main):024:0> an_array[0]
=> "some dirt"
irb(main):025:0> an_array.first
=> "some dirt"
```


#### Defining methods
Use the `def` keyword to open a method and the `end` keyword to close it. 
The last thing evaluated is the return value (implicit return). Methods take arguments, ordered and keyword are two major types you’ll see.
```
def simple_greeting
  puts "Hi, I'm a method! Nice to meet ya!"
end

def slightly_nicer_greeting(your_name)
  puts "Hi, #{your_name}, I'm a method! Nice to meet ya!"
end

def very_personal_greeting(your_name:, your_favorite_color:)
  puts "Hi, #{your_name}! I also like the color #{your_favorite_color}!"
end

def is_that_so?
  puts "Hi, I'm a method! Nice to meet ya!"
  true
end
```

####  Logical operators && control flow
```
this = true
that = false

# we use && to say both must be true
if this && that
  puts "ha"
end

# we use || to say either must be true
if this || that
  puts "yep!"
end

# we can have many branches of a conditional 
if this || that
  puts "yep!"
elsif that
  puts "nope"
else
  puts "try again later"
end

# we also have unless, which is a cute backwards if
puts "hi!" unless that
```

To majorly oversimplify things, Ruby is mostly used in a synchronous way, which means that we do everything in the order it is called and it’s pretty easy to understand what will happen in what order most of the time. So if you call one method, you can expect to wait for it to complete and return before continuing onto the next bit of logic. (This is different from say, JavaScript, where [the event loop](https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop) controls the order of execution.)

You can read more about how the prior statement is somewhat factually incorrect in [an article](https://www.toptal.com/ruby/ruby-concurrency-and-parallelism-a-practical-primer) about Ruby concurrency and parallelism.

#### Variable scope
Local variables are scoped to the method they are created in, instance variables are scoped to the instance of the class they describe, and constants are global.

```
def a_little_method
  a_little_local_var = 'here i am!'
end

irb(main):056:0> a_little_local_var
Traceback (most recent call last):
        4: from /Users/mlgore/.rbenv/versions/2.7.5/bin/irb:23:in `<main>'
        3: from /Users/mlgore/.rbenv/versions/2.7.5/bin/irb:23:in `load'
        2: from /Users/mlgore/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/irb-1.2.6/exe/irb:11:in `<top (required)>'
        1: from (irb):56
NameError (undefined local variable or method `a_little_local_var' for main:Object)
Did you mean?  a_little_method


```

#### Defining and initializing classes
```
class SparklyUnicorn
  def initialize(name:, favorite_candy:)
    @name = name
    @favorite_candy = favorite_candy
	end

  def greet
	  "Hi, I'm #{@name}. Would you like some #{@favorite_candy}?"
  end
end

# We often use classes to make new instances of objects with certain behavior. Let's see how this works:
irb(main):051:0> daffodil = SparklyUnicorn.new(name: 'Daffodil', favorite_candy: 'Twizzlers')
=> #<SparklyUnicorn:0x000000015615afe8 @name="Daffodil", @favorite_candy="Twizzlers">
irb(main):052:0> daffodil.greet
=> "Hi, I'm Daffodil. Would you like some Twizzlers?"
```

#### Inheritance and Mixins
In Ruby each class can only inherit from one other, but we can also share behavior by injecting modules into classes.  Inheritance is a big topic, but here’s the basic gist:
```
class Horse
  def initialize(name:)
    @name = name
  end

  def has_hooves?
    true
  end 
end

class Unicorn < Horse
  def initialize(name:, favorite_candy:)
    @favorite_candy = favorite_candy
  end

  def has_horn?
    true
  end
end

# See how Unicorn shares behavior inherited from Horse:
irb(main):079:0> pokey = Horse.new(name: 'Pokey')
=> #<Horse:0x000000015621b748 @name="Pokey">
irb(main):080:0> pokey.has_hooves?
=> true
irb(main):081:0> cherry = Unicorn.new(name: 'Cherry', favorite_candy: 'Skittles')
irb(main):093:0> cherry.has_horn?
=> true
irb(main):094:0> cherry.has_hooves?
=> true
```

This topic gets twisty, so you can learn *more* about how modules help share behavior in Ruby [elsewhere](https://dev.to/abbiecoghlan/ruby-modules-include-vs-extend-vs-prepend-4gmc).

### Resources
#### High level learning about Ruby
* [Ruby in Twenty Minutes](https://www.ruby-lang.org/en/documentation/quickstart/)
* [Learn Ruby with the Edgecase Ruby Koans](http://rubykoans.com/)
* [Ruby From Other Languages](https://www.ruby-lang.org/en/documentation/ruby-from-other-languages/)
* [Ruby gotchas for the JavaScript developer - Calendly.com](https://calendly.com/blog/ruby-gotchas-javascript-developer)

#### Diving deeper
* [Practical Object-Oriented Design in Ruby: An Agile Primer - Sandi Metz](https://books.google.com/books/about/Practical_Object_Oriented_Design_in_Ruby.html?id=VRCv_bATuSIC&source=kp_book_description) is an absolute classic. Or you can watch the [talk](https://drive.google.com/file/d/1VL48w9TNW-0lnoe7rATtalVAJAnAIQl7/view?usp=sharing) Sandi gave at ActBlue(!!!) 

## Ruby on Rails!
### Convention over Configuration
What we think of as “Rails magic” is just a way of naming and organizing things that lets you skip writing some boilerplate code.  

Rails expects you to use Ruby in an object-oriented way so that users can take CRUD (create, read, update, delete) actions on resources (RESTful HTTP is an influence on this) and then wires it all together based on assuming things are named a certain way!

### MVC -> Model, View, Controller
To zoom back out, Rails is based on a web application architectural pattern called MVC (Model / View / Controller). This is a way of organizing a web application to respond to an incoming request that organizes code function into three areas: a model to represent an instance of a resource being accessed (typically stored in a single database row), a view to show this information to the user in the browser and allow interaction, and a controller to receive the request from the user’s browser, collect and tidy the data for their needs, and then pass back the rendered HTML for the view to their browser via an HTTP response. 

This is also how the folders in the Indigo repo are organized: models, controllers, and views all have their place under the `/app` top level hierarchy and files within are named in a way that Rails can use to link all three together.

### Live code! Anatomy of an HTTP request handled by Rails
I have a little toy app I use for learning and teaching, which is a concept I super recommend. The one I’ll open now is called `floofapp`, and it is right now a super simple rails app that is supposedly going to grow up and be a blog, but right now it only has articles and no other features.

Let’s illustrate how Rails does things by adding the idea of a comment to my [blog project]([mlg-/floofapp: toy rails app](https://github.com/mlg-/floofapp)).

#### 8 STEPS IS ALL IT TAKES TO GOBBLE VC FUNDING AND FLY TO THE MOON IN A PICNIC BASKET
1. Write a database migration! This allows us to modify the database in a way that is reproducible in all other environments. It’s just some code using methods Rails provides that runs a change operation on the database.

 (I use `rails generate migration` for this task but tend to avoid using other rails generate commands bc the files created are bloated for my needs, typically. You can read [more on Rails generators](https://guides.rubyonrails.org/command_line.html#bin-rails-generate) if you like!

```
# from the command line in my rails project directory
rails generate migration adds_comments

# the file Rails generates in my project in app/db/migrate
class AddsComments < ActiveRecord::Migration[6.0]
    def change
    create_table :comments do |t|
      t.text :body
      t.string :author
      t.belongs_to :articles

      t.timestamps
    end
  end
end

```

We can see that this table is now in the database, but it doesn’t have any content yet, and Rails doesn’t know it exists:

```
# from the command line in your project directory
rails dbconsole

sqlite> .tables
ar_internal_metadata  comments
articles              schema_migrations
```

You can see that Rails doesn’t yet really know what a `Comment` is if you open the _Rails_ console:
```
# from the command line in your project directory
rails c

[1] pry(main)> Comment.new
NameError: uninitialized constant Comment
from (pry):1:in `__pry__'
```

The `uninitialized constant` error means that the Ruby running in this Rails app can’t find anything called a Comment. So let’s teach it how one is made!
2. Write a VERY simple model. Models are named singularly to represent an instance of an object, whereas the table of all of those objects we created in step one is plural.
in `app/models`
```
class Comment < ActiveRecord::Base
  belongs_to :article
end

# also add the other side of the relationship to article.rb
  has_many :comments
```

Check to see if Rails knows what a `Comment` is now:
```
# from the command line in your project directory
rails c

[1] pry(main)> Comment.new
   (0.6ms)  SELECT sqlite_version(*)
=> #<Comment:0x00007f9a05a72578 id: nil, body: nil, author: nil, articles_id: nil, created_at: nil, updated_at: nil>
```

Success! 🎉 But we’d probably like to see the comments somewhere, so how can we do that?

Let’s pretend we are a moderator for the blog and we need to see all comments as they come in on any article so we can know if we need to delete any spam advertising free ways to make basketballs at home for millions of dollars.

First, we have to tell Rails where a web browser would go to try to see all the comments. That involves setting up a _route_.

3. Set up `routes.rb`. There are many ways to define routes, but today we’ll use `resources` to represent the idea that a comment is a resource we expect to make available on our server. (This is following a RESTFUL application design, a good spot to read about that is on [this Google Cloud help doc](https://cloud.google.com/apis/design/resources).

Let’s tell the routes file that we have a resource called `comments`!
```
# in app/config/routes.rb
resources :comments, only: [:index]
```

Now when we restart our Rails app (typically necessary for changes made in the `config` directory!), we can see that Rails knows about the `/comments` url but the corresponding controller to handle that request in more detail is missing. So let’s add it!

4. Set up the controller. 
Add a file in `/app/controllers` called `CommentsController`. Once again, the name is plural to reflect that this controller manages routes related to the viewing, modification, and deletion of comments. 

We’ll also add an action called `index`, which is a conventional way to name a page where we see all of some resource that exists on our server.

```
class CommentsController < ApplicationController

  def index
  end
end

```

Rails helpfully lets us know we need a corresponding template to show whatever is supposed to be on `/comments`, so let’s add that, too!
5. Set up a view. In `/app/views` you’ll add `comments` folder and then a `index.html.erb` file in that folder, that allows you to embed ruby into HTML to show information in your view. (Many of our views use a Javascript framework to render the FE these days, but it helps to know where to look for the many static templates that still exist)
6. Make the request! Go to http://3000/comments. Cool! It’s a blank page!
7. Add some records using the rails console to make things more realistic-ish! 
```
# from the command line in your project directory
rails c

Comment.create(body: 'this site is the worst and you smell like pizza', author: 'a cranky radish', article: Article.first)

Comment.create(body: 'i love your blarg and you should be very proud', author: 'mom', article: Article.first)
```

And then grab all those to hand to the controller action:

```
class CommentsController < ApplicationController

  def index
    @comments = Comment.all
  end
end

```
8. profit (… but like, actually, tbh!) 

So there you have it! [The simplest possible example](https://github.com/mlg-/floofapp/pull/1) of how Rails makes it hella fast to set up a basic web app.

## Audience questions!
> -Would you use the Ruby hash in the same way you’d use an object in JavaScript, or a dictionary in Python?

Maybe sometimes, it depends on the use case for sure! 

In Javascript a hash is more like an instance of a ruby class, in that it responds to messages like `object.some_key` when it is structured like so:
```
const object = {
  some_key: 'some value'
}
```

With a Ruby hash, calling `object.some_key` would give you a `NoMethodError`, but you can grab any of the values stored by key like so:
```
irb(main):001:1* object = {
irb(main):002:1*   some_key: 'some value'
irb(main):003:0> }
=> {:some_key=>"some value"}
irb(main):004:0> object[:some_key]
=> "some value"
```

In Python dictionaries, the key: value pairs are _ordered_, so those are kind of a hybrid of what Ruby calls an array (ordered list of objects) and a hash (unordered list of key value pairs). But both Ruby hashes and Python dictionaries enforce uniqueness for keys, so they have that in common!

Try [this article]([Ruby Hash - Definition, Examples & Methods: The Ultimate Guide](https://www.rubyguides.com/2020/05/ruby-hash-methods/)) for a little more about what you can do with hashes in Ruby!

> Any more-or-less common Ruby errors we should watch out for and what do those look like?

This could be a talk unto itself but as I hinted at, the flexibility of Ruby can also sometimes be its gotcha! One case that happens pretty frequently (see for yourself in #ats-bugsnag-notifications on Slack!) is the `NoMethodError`. This often happens either: 

1. When something is unexpectedly `nil`  (`nil` itself is an object in Ruby like everything else, but it’s a special one that represents nothing and has a limited interface).
2. When an object handed back can’t respond to the methods we expected it to be able to (which is actually the same as the first problem, but generalized to all objects and not just the special `nil` object).

A way that I like to try to solve the “oops that was `nil`  “ issue in my code when possible is something called the Null Object Pattern. This is a programming pattern where we pass an instance of an object that we expect to be available, but it’s often one that has no attributes filled out. 

What do I mean by that? Here’s [an example](https://github.com/actblue/indigo/blob/1d01099e18e7dbe113e12195fc1a33669fcc885c/app/controllers/api/auth/one_time_passwords_controller.rb#L54) I wrote in Indigo! (slightly simplified below)
```
session_user || User.new
```

Here I expect to have a `session_user`, but sometimes I might not. I might have downstream code that expects to receive a `User` object, so rather than either locating the `session_user` (an instance of `User`) or passing back `nil` to the calling code, I can return an empty instance of `User` by calling its initializer (`User.new`) but not handing it any values. 

This will make an empty little shell user. It will have all the right methods available (quacking like a duck, remember!) but it won’t have any information. This will allow it to pass through the calling code without raising `nil` exceptions or relying on what can sometimes be ugly/icky `if such_and_such.present?` calls.

Learn more in [this iconic Sandi Metz talk](https://www.youtube.com/watch?v=OMPfEXIlTVE))!

> Maybe I missed this, but can/does Ruby check types like Typescript does?

This is a hot topic! Type checking came natively to Ruby in version 3 with a system called `RBS`. You can read more detail in [this blog post](https://developer.squareup.com/blog/the-state-of-ruby-3-typing/) from a core contributor or in the [release notes]([Ruby 3.0.0 Released](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/)) for Ruby 3 under the `RBS` heading. Previously, there were solutions like [Sorbet](https://sorbet.org/). 

I will refrain from sharing my opinion about any of these until I have a chance to work with them, because my gut reaction is “ew” but it’s an “ew” without context, which is useless to you (and to me, and my own professional growth mindset! haha)

> What is a “fuzzy find”??? Why is it so fluffy?

IT’S SO FLUFFY IM GONNA DIE DOT GIF!

I was referring to the fuzzy finder feature of my text editor, Sublime Text. There is also a fuzzy find feature in Github, check it out when browsing a repo by hitting `T`. It is so fluffy bc I barely need to be caffeinated to use it, as long as the letters I type are in the right order (omissions allowed) for the file’s name, it will be included in the list! Neat! ✨