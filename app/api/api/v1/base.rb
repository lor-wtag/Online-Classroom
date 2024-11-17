module API
  module V1
    class Base < Grape::API
      version "v1", using: :path
      format :json

      mount API::V1::Users
      mount API::V1::Classrooms
    end
  end
end
