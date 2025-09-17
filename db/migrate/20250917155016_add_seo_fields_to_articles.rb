class AddSeoFieldsToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :meta_title, :text
    add_column :articles, :meta_description, :text
    add_column :articles, :keywords, :text
    add_column :articles, :global_meta_title, :text
    add_column :articles, :global_meta_description, :text
    add_column :articles, :global_keywords, :text
  end
end
