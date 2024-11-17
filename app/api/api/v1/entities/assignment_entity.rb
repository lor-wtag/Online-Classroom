module API
  module Entities
    class AssignmentEntity < Grape::Entity
      expose :id, :title, :description, :classroom_id, :due_date, :created_at, :updated_at
    end
  end
end
