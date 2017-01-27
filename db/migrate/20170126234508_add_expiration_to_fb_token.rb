class AddExpirationToFbToken < ActiveRecord::Migration[5.0]
  def change
    add_column :fb_tokens, :expires, :datetime
  end
end
