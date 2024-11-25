module V1
  module Entities
    class Classrooms < Grape::Entity
      expose :id
      expose :name
      expose :course_code
      expose :classroom_code
      expose :user_id
      expose :created_at
      expose :updated_at
    end
  end
end
