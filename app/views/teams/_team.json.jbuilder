json.extract! team, :id, :name, :member_id, :purpose, :created_at, :updated_at
json.url team_url(team, format: :json)