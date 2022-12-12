class CommentMailer < ApplicationMailer

  def approval_notice(comment_id)
    @commenter = Comment.find_by(id: comment_id).user
    mail(to: @commenter, subject: 'Your comment has been approved!')
  end
end
