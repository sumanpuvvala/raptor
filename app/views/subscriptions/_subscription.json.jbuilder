json.extract! subscription, :id, :course_id, :member_id, :status, :rating, :comment, :created_at, :updated_at
json.url subscription_url(subscription, format: :json)