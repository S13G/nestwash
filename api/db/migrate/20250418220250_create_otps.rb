class CreateOtps < ActiveRecord::Migration[8.0]
  def change
    create_table :otps, id: :uuid do |t|
      t.string :otp_digest, null: false, index: { unique: true }
      t.datetime :expires_at, null: false
      t.boolean :used, default: false
      t.timestamps
    end
  end
end
