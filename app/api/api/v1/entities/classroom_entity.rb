module API
  module Entities
    class ClassroomEntity < Grape::Entity
      expose :id, :name, :user_id, :created_at, :updated_at
    end
  end
end
