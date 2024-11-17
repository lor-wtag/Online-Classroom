# app/api/v1/classrooms.rb
module API
  module V1
    class Classrooms < Grape::API
      resource :classrooms do
        desc "Fetch all classrooms"
        get do
          classrooms = Classroom.all
          present classrooms, with: API::Entities::ClassroomEntity
        end


        desc "Fetch a specific classroom"
        params do
          requires :id, type: Integer, desc: "Classroom ID"
        end
        get ":id" do
          classroom = Classroom.find(params[:id])
          present classroom, with: API::Entities::ClassroomEntity
        end

        desc "Create a new classroom"
        params do
          requires :name, type: String, desc: "Classroom Name"
          requires :user_id, type: Integer, desc: "Teacher ID"
        end
        post do
          classroom = Classroom.new(declared(params))
          if classroom.save
            present classroom, with: API::Entities::ClassroomEntity
          else
            error!({ error: classroom.errors.full_messages }, 422)
          end
        end
      end
    end
  end
end
