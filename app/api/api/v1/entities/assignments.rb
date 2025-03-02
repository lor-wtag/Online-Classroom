module V1
  module Entities
    class Assignments < Grape::Entity
      expose :id
      expose :title
      expose :description
      expose :classroom_id
      expose :due_date
    end
  end
end
