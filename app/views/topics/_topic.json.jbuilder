json.extract! topic, :id, :name, :category_id, :classification_id, :team_id, :details, :created_at, :updated_at
json.url topic_url(topic, format: :json)