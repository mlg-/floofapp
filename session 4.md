# Intro the Rails, Session 4: Mailers
## What are mailers?
`ActionMailer` is the part of Rails that makes it easy to send emails (typically transactional emails, which are sent when a user takes an action in your application that requires notification) with dynamic content.

## How do I quickly set one up?
Mailers are set up in a pretty similar way to controllers and HTML views. Setting up a new mailer can be done using the rails generator, i.e.
`rails generate mailer User` (or you can create a few of the files you know you’ll need manually), which will produce:

```
create  app/mailers/user_mailer.rb
create  app/mailers/application_mailer.rb
invoke  erb
create    app/views/user_mailer
create    app/views/layouts/mailer.text.erb
create    app/views/layouts/mailer.html.erb
invoke  test_unit
create    test/mailers/user_mailer_test.rb
create    test/mailers/previews/user_mailer_preview.rb
```

## An example of mailers from a prior session, stepped through with pry!
You might remember that two sessions ago I set up a mailer for us to demonstrate how the callback cycle on ActiveRecord works. This was the `CommentMailer`. Let’s step through how it works using `pry`. I’ll put one in the `Comment` model, one in the action called in the `CommentMailer`, and one in the template the mailer renders `app/views/comment_mailer/approval_notice.html.erb`.

The `CommentMailer` is sent when I update a comment’s status to `approved`. So let’s open a rails console ( `rails c` in your project directory) to trigger that change. 

[demo]

1. Record meets change criteria, aside about ActiveJob coming later in Nat’s talk / `deliver_later` vs `deliver_now`
2. `mail` method in the action is the magic part that sends it, lots of settings available for things like attachments, headers, etc
3. i-vars and also the mailer instance available in the template for dynamic content!

## An aside about text email templates
One thing I did _not_ do last time is set up a text-only email equivalent for my approval notice mailer. This is the plain, text only (no HTML) email that is sent when a mail client prefers or can only read plain text. This is less common than it used to be, but it’s courteous to set it up so that clients using it for accessibility or bandwidth capacity reasons can have equal access to the mailers you send.

## Previewing your mail!
There are a couple options for checking out the mailers you’ve created locally, or debugging those.
1. You can use a tool like [Mailcatcher]([MailCatcher](https://mailcatcher.me/)) to give you a little web UI for everything that goes to the SMTP port on your computer. I have it running on my computer now so let’s go see the email we just sent: [MailCatcher](http://127.0.0.1:1080/).
2. You can use [mailer previews](https://guides.rubyonrails.org/action_mailer_basics.html#previewing-emails), a feature of Rails. Ideally you’d always set up mailer previews for the benefit of other people in the future who want to be able to easily see how an email would look when sent to an end user without needing to trigger the behavior programmatically or otherwise. Let’s walk through how to do this!
	1. Create a file in `test/mailers/previews/comment_mailer_preview` (in Indigo we have these in the `lib/previews` folder, just a heads up)
	2. Set up an action that matches the name of the one in your original mailer file, i.e. `CommentMailer.approval_notice`, and then provide it with any necessary data to render the preview (In Indigo we have factories included so we can create accurate data much like we do for tests, but this might be overkill in less complex cases).  For example…
```ruby
class CommentMailerPreview < ActionMailer::Preview
  def approval_notice
    user = User.create!(first_name: 'Walt', last_name: 'Whitman', email: 'mlg@whee.co')
    comment = Comment.create!(user: user, body: 'this article contains multitudes just like me', article: Article.first, status: 'pending')
    CommentMailer.with(commenter: user).approval_notice(comment.id)
  end
end
```
	 3. Now when we visit localhost:3000/rails/mailers in the browser, there she be!

## Another aside about urls
When adding a link in a mailer template, you want to always use the `_url` version of the route helper you need. So, for example, `articles_url` vs `articles_path`. This is because the user is not already on your host in their email client, so we need to know what website `/articles` is on to begin with!

## And finally, mailers have callbacks
If you want to repeat some logic for multiple mailers (before or after or both aka “around”), just like in your controller, you can do that! They have [callbacks](https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-callbacks)built in too.

More about mailers!
Check out the [Rails Guide]([Action Mailer Basics — Ruby on Rails Guides](https://guides.rubyonrails.org/action_mailer_basics.html)) to `ActionMailer`	basics!