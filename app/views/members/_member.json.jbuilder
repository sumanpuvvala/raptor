json.extract! member, :id, :name, :title, :stream, :manager, :is_lead, :created_at, :updated_at
json.url member_url(member, format: :json)