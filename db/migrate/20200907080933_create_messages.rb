class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :chat_group, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
