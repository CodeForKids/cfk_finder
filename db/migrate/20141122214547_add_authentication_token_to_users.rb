class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token

    User.all.each do |u|
      u.save
    end
  end
end
