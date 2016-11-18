module ApplicationHelper
  def author(object)
    object.user_id == current_user.id
  end
end
