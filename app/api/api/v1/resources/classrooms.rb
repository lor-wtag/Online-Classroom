module V1
  module Resources
    class Classrooms < Grape::API
      version "v1", using: :path
      format :json
      prefix :api
      resource :classrooms do
        desc "Fetch all classrooms"
        get do
          classrooms = Classroom.all
          present classrooms
        end


        desc "Fetch a specific classroom"
        params do
          requires :id, type: Integer, desc: "Classroom ID"
        end
        get ":id" do
          classroom = Classroom.find(params[:id])
          present classroom
        end

        desc "Create a new classroom"
        params do
          requires :name, type: String, desc: "Classroom Name"
          requires :user_id, type: Integer, desc: "Teacher ID"
          requires :course_code, type: String, desc: "Course Code"
          requires :classroom_code, type: String, desc: "Classroom Code"
        end
        post do
          classroom = Classroom.new(declared(params))
          if classroom.save
            present classroom
          else
            error!({ error: classroom.errors.full_messages }, 422)
          end
        end
      end
    end
  end
end
