class PrepareDatabase < ActiveRecord::Migration
  def self.up

    create_table :users do |t|
      t.timestamps
      t.string   :login,            :default => nil, :null => true
      t.string   :crypted_password, :default => nil, :null => true
      t.string   :password_salt,    :default => nil, :null => true
      t.string   :persistence_token,                 :null => false
      t.integer  :login_count,      :default => 0,   :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string   :last_login_ip
      t.string   :current_login_ip
      t.string   :openid_identifier
      t.string   :identifier
      t.string   :name
      t.string   :email
      t.boolean  :admin,            :default => false
      t.integer  :facebook_uid,     :limit => 8
    end

    add_index :users, :login
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    add_index :users, :openid_identifier
    add_index :users, :facebook_uid

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text   :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

  create_table :contents do |t|
    t.string :title
    t.string :type
    t.text :body
    t.text :source
    t.string :shortname
    t.boolean :published
    t.datetime :published_at
    t.integer :hits, :default => 0
    t.timestamps
    t.references :user
    t.integer :comments_count, :default => 0
    t.integer :category_id, :default => 0, :null => false
  end

  add_index :contents, :title
  add_index :contents, :user_id

  create_table :comments, :force => true do |t|
    t.string :title, :limit => 50, :default => ""
    t.string :comment, :default => ""
    t.timestamps :created_at, :null => false
    t.integer :commentable_id, :default => 0, :null => false
    t.string :commentable_type, :limit => 15,
      :default => "", :null => false
    t.references :user, :default => 0, :null => false
    t.references :content, :default => 0, :null => false
    t.string :author_name
  end

  add_index :comments, :commentable_id
  add_index :comments, :commentable_type

  create_table :categories do |t|
    t.string :title
    t.string :description
    t.string :shortname    
    t.timestamps
  end

  end

  def self.down
    drop_table :users
    drop_table :sessions
    drop_table :contents
    drop_table :comments
  end
end
