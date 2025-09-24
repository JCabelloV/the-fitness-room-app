class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def up
    # Solo agrega lo que no exista aún
    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, null: false, default: ""
    end

    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string
      add_column :users, :reset_password_sent_at, :datetime
    end

    unless column_exists?(:users, :remember_created_at)
      add_column :users, :remember_created_at, :datetime
    end

    # Opcionales (quítalos si no los usarás):
    # Trackable
    unless column_exists?(:users, :sign_in_count)
      add_column :users, :sign_in_count, :integer, default: 0, null: false
      add_column :users, :current_sign_in_at, :datetime
      add_column :users, :last_sign_in_at, :datetime
      add_column :users, :current_sign_in_ip, :inet
      add_column :users, :last_sign_in_ip, :inet
    end

    # Confirmable (opcional)
    # unless column_exists?(:users, :confirmation_token)
    #   add_column :users, :confirmation_token, :string
    #   add_column :users, :confirmed_at, :datetime
    #   add_column :users, :confirmation_sent_at, :datetime
    #   add_column :users, :unconfirmed_email, :string
    # end

    # Bloquea reindex duplicado:
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
    # add_index :users, :confirmation_token, unique: true unless index_exists?(:users, :confirmation_token)
  end

  def down
    # Reverso seguro (elimina solo lo agregado arriba)
    remove_column :users, :encrypted_password if column_exists?(:users, :encrypted_password)
    remove_column :users, :reset_password_token if column_exists?(:users, :reset_password_token)
    remove_column :users, :reset_password_sent_at if column_exists?(:users, :reset_password_sent_at)
    remove_column :users, :remember_created_at if column_exists?(:users, :remember_created_at)

    if column_exists?(:users, :sign_in_count)
      remove_column :users, :sign_in_count
      remove_column :users, :current_sign_in_at
      remove_column :users, :last_sign_in_at
      remove_column :users, :current_sign_in_ip
      remove_column :users, :last_sign_in_ip
    end

    remove_index :users, :email if index_exists?(:users, :email)
    remove_index :users, :reset_password_token if index_exists?(:users, :reset_password_token)
    # remove_index :users, :confirmation_token if index_exists?(:users, :confirmation_token)
  end
end
