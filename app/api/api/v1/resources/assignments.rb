module V1
  module Resources
    class Assignments < Grape::API
      version "v1", using: :path
      format :json
      prefix :api
      resource :assignments do
        desc "Fetch all assignments"
        get do
          assignments = Assignment.all
          present assignments, with: V1::Entities::Assignments
        end

        desc "Fetch a specific assignment"
        params do
          requires :id, type: Integer, desc: "Assignment ID"
        end
        get ":id" do
          assignment = Assignment.find(params[:id])
          present assignment, with: V1::Entities::Assignments
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
            present assignment, with: V1::Entities::Assignments
          else
            error!({ error: assignment.errors.full_messages }, 422)
          end
        end

        desc "Update an existing assignment"
        params do
          requires :id, type: Integer, desc: "Assignment ID"
          optional :title, type: String, desc: "Assignment Title"
          optional :description, type: String, desc: "Assignment Description"
          optional :classroom_id, type: Integer, desc: "Classroom ID"
          optional :due_date, type: DateTime, desc: "Due Date for the Assignment"
        end
        put ":id" do
          assignment = Assignment.find(params[:id])
          if assignment.update(declared(params, include_missing: false))
            present assignment, with: V1::Entities::Assignments
          else
            error!({ error: assignment.errors.full_messages }, 422)
          end
        end

        desc "Delete an existing assignment"
        params do
          requires :id, type: Integer, desc: "Assignment ID"
        end
        delete ":id" do
          assignment = Assignment.find(params[:id])
          if assignment.destroy
            { message: "Assignment deleted successfully" }
          else
            error!({ error: "Failed to delete assignment" }, 422)
          end
        end
      end
    end
  end
end
