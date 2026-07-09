class CreateAvailabilityNotification < ActiveRecord::Migration[8.0]
  def change
    create_table :availability_notifications do |t|
      t.string :receiver_email, null: false
      t.references :variant, null: false, foreign_key: { to_table: :spree_variants }

      if t.respond_to?(:jsonb)
        t.jsonb :variant_options, null: true, default: {}
      else
        t.json :variant_options, null: true, default: {}
      end

      t.datetime :synced_at, null: true
      t.timestamps
    end

    add_index :availability_notifications, :receiver_email
  end
end
