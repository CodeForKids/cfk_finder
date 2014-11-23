class Parent < BaseUser
  has_many :kids, foreign_key: :parent_id
end
