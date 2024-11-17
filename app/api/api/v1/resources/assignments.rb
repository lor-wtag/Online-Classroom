module API
  module V1
    class Assignments < Grape::API
      resource :assignments do
        desc "Fetch all assignments"
        get do
          assignments = Assignment.all
          present assignments, with: API::Entities::AssignmentEntity
        end


        desc "Fetch a specific assignment"
        params do
          requires :id, type: Integer, desc: "Assignment ID"
        end
        get ":id" do
          assignment = Assignment.find(params[:id])
          present assignment, with: API::Entities::AssignmentEntity
        end

        desc "Create a new assignment"
        params do
          requires :title, type: String, desc: "Assignment Title"
          requires :description, type: String, desc: "Assignment Description"
          requires :classroom_id, type: Integer, desc: "Classroom ID"
          optional :due_date, type: DateTime, desc: "Due Date for the Assignment"
        end
        post do
          assignment = Assignment.new(declared(params))
          if assignment.save
            present assignment, with: API::Entities::AssignmentEntity
          else
            error!({ error: assignment.errors.full_messages }, 422)
          end
        end
      end
    end
  end
end
