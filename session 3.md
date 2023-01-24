# # Intro to Ruby on Rails, Session 3: V, C, and P-R-Y
## Intro! ✨
### pre-reqs
1. some knowledge of any programming or scripting language
2. basic understanding of [how the web works](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/How_the_Web_works): HTTP request-response cycle

### goals
To offer a whirlwind, syllabus outline level tour of Ruby on Rails (with nods to the quirks of Indigo) 

### non-goals
To be exhaustive or complete, to get deep on any one topic! Please leave your weed fertilizer at home, thank you!!

### last time!
Last time we talked about the M part of Rails’ MVC design, the powerful ORM ActiveRecord. We talked about how ActiveRecord lets us validate, query, and manage our database records in a way that feels natural and object-oriented.

### today!
Today we’re going to talk about the C and the V in MVC, controllers and views. And along the way we’re going to learn syntax for using a powerful debugging tool available for use in Ruby called pry.

## Introducing ActionController!
### What is a controller?
The “C” in MVC is for “controller,” a bit of code that accepts HTTP requests, takes some actions, and then returns a response. In Rails the parent class for all controllers that gives them some powerful features and that good old Rails Magic™️ is called `ActionController`.

In Rails the request is first processed by the router, a bit of code set up in `config/routes.rb` in most Rails apps (including Indigo).  

For example, our little bloggy toy app, `floofapp`, has a `routes.rb` file that looks like this: 
```
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'articles#index'

  resources :articles, only: [:index]
  resources :comments, only: [:index]
end
```

### Rails “magic” is, as usual, all in the naming. Routes -> Controllers
The `resources :articles` is a little bit of Rails magic. Your Rails app assumes that you roughly have routes that correspond to your database tables. Controllers are named in _plurally_ to reflect that, just like database tables. So when Rails goes to figure out what controller should handle requests to `/article`, it will look for an `ArticlesController` in the `app/controllers/*` folder first.

There’s a neat little task you can run to show you a table of all the routes your app has set up called `rails routes` . Typically with Indigo I pipe the text results of this output through to an additional `grep` (a standard text searching command line tool in Unix-like systems) command to search it for some keyword since otherwise it’s a ton of text to try to look at. The routes are returned as a table of results like so:

```
➜  floofapp git:(session-3) rails routes | grep article
                                 root GET    /                                                                                        articles#index
                             articles GET    /articles(.:format)                                                                      articles#index
```

The columns correspond to these headings:
path helper name | HTTP verb | url path | controller#action

The `articles#index` part tells us that Rails will look for a controller file called `ArticlesController` and then a method (also called an `action` in this particular context) called `index` to know how to handle any `GET` HTTP requests to the url `/` (that’s the `root` part) or `/articles`. 

All the “magic” CRUD routes/actions are:
1. `new` (`GET` to `/articles/new`)
2. `create`  (`POST` to `/articles`)
3. `edit` (`GET` to `/articles/<id>/edit`)
4. `update` (`POST` to `/articles/<id>`)
5. `index` (`GET` to `/articles`)
6. `show` (`GET` to `/articles/<id>`)

Not all routes are CRUD/REST based, of course, and there are lot of ways to configure custom routes. We won’t have time to dive into that today, but it’s well-described in ([Rails Routing from the Outside In — Ruby on Rails Guides](https://guides.rubyonrails.org/routing.html)).

### `params` hash

Rails provides a nice wrapper around the POST body of a request or the query string parameters: `params`. You can access this anywhere in your controller and query it like you would other hashes.

For example: 

```
localhost:3000/articles?floop=shoop&whoop=scoop
```

We can see the server has accepted these query string parameters in the server log:

```
Started GET "/articles?floop=shoop&whoop=scoop" for ::1 at 2022-12-13 15:36:48 -0500
   (0.9ms)  SELECT sqlite_version(*)
   (0.3ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
Processing by ArticlesController#index as HTML
  Parameters: {"floop"=>"shoop", "whoop"=>"scoop"}
```

And now, if we put a break point (`binding.pry` , pry alert!!!) in the `ArticlesController#index` action, we’ll see the key/value pairs available to us at the local var `params`:

```
class ArticlesController < ApplicationController
  def index
    binding.pry
    @articles = Article.all
  end
end
```

If we run the request again, we’ll have access to the `params` variable at our breakpoint in the tab in the terminal where `rails s` is running:

```
Processing by ArticlesController#index as HTML
  Parameters: {"floop"=>"shoop", "whoop"=>"scoop"}

From: /Users/mlgore/workspace/floofapp/app/controllers/articles_controller.rb:3 ArticlesController#index:

    2: def index
 => 3:   binding.pry
    4:   @articles = Article.all
    5: end

[1] pry(#<ArticlesController>)> params
=> <ActionController::Parameters {"floop"=>"shoop", "whoop"=>"scoop", "controller"=>"articles", "action"=>"index"} permitted: false>
```

Let’s say I forgot how to call the `params` hash in my controller. My `pry` breakpoint has an `ls` command available that lists all the methods, variables, etc that are currently in scope, and you can see I have a `params` getter and setter method provided by `ActionController::StrongParameters#methods` in the output. lt accepts many options to narrow down the input, run `ls -h` to see all.

```
From: /Users/mlgore/workspace/floofapp/app/controllers/articles_controller.rb:3 ArticlesController#index:

    2: def index
 => 3:   binding.pry
    4:   @articles = Article.all
    5: end

[1] pry(#<ArticlesController>)> ls
...
ActionController::StrongParameters#methods: params  params=
...
```

While we’re in this breakpoint, let’s also look around at some other things that are specific to the controller context. Every controller also has a `request` object, which gives you a friendly interface for all the stuff that came in with the HTTP request, as well as `response`, which helps you get an idea of what you’re sending back!

## Strong params
But back to `params`! When creating or updating a record in the database using user-provided-input, we use what’s called a “strong params” pattern, which filters the attributes we will allow to be passed onward. 

The strong params pattern protects against a web application vulnerability termed “[mass assignment](https://cheatsheetseries.owasp.org/cheatsheets/Mass_Assignment_Cheat_Sheet.html).”  It ensures malicious users can’t update things we didn’t expect, like attributes that weren’t on the destination page/form but might be available on the object itself. 

Let’s set up an example using our toy blog app in the `ArticlesController#create` :

```
class ArticlesController < ApplicationController
  ....
  def create
    binding.pry
    article = Article.create(article_params)
    if article.persisted?
      redirect_to articles_path
    else
      render :new
    end
  end


  private

  def article_params
    params.require(:article).permit(:title, :body, :user_id)
  end
end

```

The `require` is a top-level params hash key that is expected, and then `permit` is everything that’s allowed to be inside that hash and set on the new record that is created.

### filters - before, after, around

Another powerful feature of `ActionController` are its callbacks, called `filter`s. 

Let’s say I realize not having any authentication on the page to publish a new article isn’t… the best plan. I can add some code in a `filter` that runs before, after, or both before and after (we call that “around”) a controller action.

Let’s see an example in the `ArticlesController` of our toy app.

i.e.:

```
class ArticlesController < ApplicationController
  before_action :login_please, only: [:new, :create]

...

  def login_please
    redirect_to articles_path unless session_user
  end

  def session_user
    false
  end
end

```

Now whenever I try to go to the form to create a new article, I’ll be redirected the to main blog homepage, because I’m not allowed to be there!

### returning a response!
So far we’ve been mostly doing hard redirects and serving html views. But what if you want to return a `json` response from your controller action?

You can do that with `render`. Before, our `render` in the `ArticlesController#index` was implied by “Rails Magic,” but now it can be explicit and return `json` when appropriate:

```
class ArticlesController < ApplicationController
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end
```

Now doing a `curl` with an `Accept: application/json` header will return json instead of the HTML body of the page:
```
➜  floofapp git:(session-3) ✗ curl 'localhost:3000/articles' -H "Accept: application/json"
[{"id":1,"title":"This is an anxietycore news headline, get scared","body":"nihilist despair","user_id":5,"created_at":"2022-11-29T19:25:25.571Z","updated_at":"2022-11-29T19:25:25.571Z"},{"id":2,"title":"This is a post about how cute dogs are","body":"spoiler: really darn cute","user_id":5,"created_at":"2022-11-29T19:25:25.575Z","updated_at":"2022-11-29T19:25:25.575Z"}
```

## Introducing ActionView!
### What’s in a name? Everything… as usual!
Rails maps the names of the controller actions to HTML templates in folders in the `/views` of your application. So when we go to `/articles`, that maps to `ArticlesController#index`, which looks for an html template to render for the user from `views/articles/index.html.erb` when the action is complete.

You can also set up templates for other types of responses, but this is less common in Indigo, so I’m not going to bother going into that.

Templates can be included in other templates. So if we wanted to create a view for seeing many comments at once that could be shared in multiple layouts, we’d prefix the template with an underscore: `_index.html.erb` and then we can include it in our articles index, for example, like this:

```
<%= render 'comments/index', comments: article.comments %>

```

ActionView also has *tons* of helpers to quickly build html elements, forms, links, and and other elements you typically need to include. I won’t be discussing those in detail today because we are mostly moving away from rendering views with html served by Rails views in favor of React interfaces in ATS, but I’m happy to point you to some more resources for maintaining the ones we have.

## Putting it all together
So there you have it, the M-V-C framework for Rails! To really drive it home, I’m going to use a rails command that I don’t often use professionally, but gives you a sense of what Rails considers the basic setup of a new resource: `rails scaffold tags`.

You can see here all of the elements rails sets up and how it names those! This makes it really clear how it ties together the names and file structure to make commonly-repeated web application patterns easy to set up super quickly.

```
 invoke  active_record
      create    db/migrate/20221213233338_create_tags.rb
      create    app/models/tag.rb
      invoke    test_unit
      create      test/models/tag_test.rb
      create      test/fixtures/tags.yml
      invoke  resource_route
       route    resources :tags
      invoke  scaffold_controller
      create    app/controllers/tags_controller.rb
      invoke    erb
      create      app/views/tags
      create      app/views/tags/index.html.erb
      create      app/views/tags/edit.html.erb
      create      app/views/tags/show.html.erb
      create      app/views/tags/new.html.erb
      create      app/views/tags/_form.html.erb
      invoke    test_unit
      create      test/controllers/tags_controller_test.rb
      create      test/system/tags_test.rb
      invoke    helper
      create      app/helpers/tags_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/tags/index.json.jbuilder
      create      app/views/tags/show.json.jbuilder
      create      app/views/tags/_tag.json.jbuilder
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/tags.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.scss
```

To roll it back, run `rails destroy scaffold tags`.

## Break for questions!!

## One way to understand how rails wires it all together? Make liberal use of pry to poke around!
`pry` is a tool (a repl to be really precise) for ruby that we use to power the Indigo rails console `rails c` and that also has powerful debugging features.

`pry` is super powerful, and to make the best use of it, I’m going to use `indigo` rather than our toy app to show you some of what it can do.

[mlg does pry · GitHub](https://gist.github.com/mlg-/c740e41381ccd66e80b6f8929fd1dcd4)

## Sources + More Resources!
* [Action Controller Overview — Ruby on Rails Guides](https://guides.rubyonrails.org/action_controller_overview.html)
* [Rails Routing from the Outside In — Ruby on Rails Guides](https://guides.rubyonrails.org/routing.html)
* [Layouts and Rendering in Rails — Ruby on Rails Guides](https://guides.rubyonrails.org/layouts_and_rendering.html)
* [Action View Form Helpers — Ruby on Rails Guides](https://guides.rubyonrails.org/form_helpers.html)
* https://github.com/pry/pry 