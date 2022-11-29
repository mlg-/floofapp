class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates :body, presence: true, if: :some_method

  validates :status, inclusion: { in: ['pending', 'approved', 'denied'] }

  after_update :email_commenter, if: :status_changed_to_approved?

  private

  def email_commenter
    CommentMailer.approval_notice(self.id).deliver_now
  end

  def status_changed_to_approved?
    saved_change_to_status? && status == 'approved'
  end

  def some_method
    # does a thing
  end
end
