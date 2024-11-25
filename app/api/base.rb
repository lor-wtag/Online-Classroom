class Base < Grape::API
  mount V1::Resources::Classrooms
  mount V1::Resources::Assignments
end
