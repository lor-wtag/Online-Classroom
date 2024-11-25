module V1
  module Entities
    class Assignments < Grape::Entity
      expose :id
      expose :title
      expose :description
      expose :classroom_id
      expose :due_date
      expose :created_at
      expose :updated_at
    end
  end
end
