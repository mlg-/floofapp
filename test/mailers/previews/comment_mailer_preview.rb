class CommentMailerPreview < ActionMailer::Preview
  def approval_notice
    user = User.create!(first_name: 'Walt', last_name: 'Whitman', email: 'mlg@whee.co')
    comment = Comment.create!(user: user, body: 'this article contains multitudes just like me', article: Article.first, status: 'pending')
    CommentMailer.with(commenter: user).approval_notice(comment.id)
  end
end
