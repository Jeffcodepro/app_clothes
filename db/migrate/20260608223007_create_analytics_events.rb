class CreateAnalyticsEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_events do |t|
      t.string :event_type
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.jsonb :metadata
      t.string :ip_hash
      t.string :user_agent

      t.timestamps
    end
  end
end
