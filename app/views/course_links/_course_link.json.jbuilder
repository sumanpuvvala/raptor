json.extract! course_link, :id, :parent_id, :child_id, :link_type, :created_at, :updated_at
json.url course_link_url(course_link, format: :json)