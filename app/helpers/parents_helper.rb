module ParentsHelper
  def delete_phrase(parent)
    "Are you sure you want to delete the parent profile for #{parent.name}?"
  end
end
