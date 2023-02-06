class CreateFederailsActors < ActiveRecord::Migration[7.0]
  def change
    create_table :actors do |t|
      t.string :name
      t.string :federated_url
      t.string :username
      t.string :server
      t.string :inbox_url
      t.string :outbox_url
      t.string :followers_url
      t.string :followings_url
      t.string :profile_url
      t.references :user, null: true, foreign_key: true

      t.timestamps
      t.index :federated_url, unique: true
    end
    remove_index :actors, :user_id
    add_index :actors, :user_id, unique: true
  end
end
