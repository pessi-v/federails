class CreateFederailsFollowings < ActiveRecord::Migration[7.0]
  def change
    create_table :followings do |t|
      t.references :actor, null: false, foreign_key: true
      t.references :target_actor, null: false, foreign_key: { to_table: :actors }
      t.integer :status, default: 0
      t.string :federated_url

      t.timestamps

      t.index [:actor_id, :target_actor_id], unique: true
    end
  end
end
