# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      can :create, User
    elsif user.teacher?
      can :show, User, id: user.id
      can :update, User, id: user.id
      can :edit, User, id: user.id
      can [:delete, :destroy], User, id: user.id
      can :manage, Classroom, user_id: user.id
      can [:read, :delete, :destroy], Enrollment, classroom: { user_id: user.id }
      can :show, User do |student|
        student.enrollments.joins(:classroom).where(classrooms: { user_id: user.id }).exists?
      end
      can :manage, Assignment, classroom: { user_id: user.id }
      can :grade, Submission, assignment: { classroom: { user_id: user.id } }
      can :read, Submission, assignment: { classroom: { user_id: user.id } }
      can :read, Comment, commentable_type: "Assignment", commentable: { classroom: { user_id: user.id } }
      can [:new, :create], Comment, commentable_type: "Assignment", commentable: { classroom: { user_id: user.id } }
      can :read, Comment, commentable_type: "Submission", commentable: { assignment: { classroom: { user_id: user.id } } }
      can [:new, :create], Comment, commentable_type: "Submission", commentable: { assignment: { classroom: { user_id: user.id } } }
      
    elsif user.student?
      can [ :show, :update, :edit, :destroy ], User, id: user.id
      can :read, Classroom, enrollments: { user_id: user.id }
      can :create, Enrollment, user_id: user.id
      can :create_enrollment, Classroom, user_id: user.id
      can :join, Classroom
      can :enroll, Classroom
      can [ :delete, :destroy ], Enrollment, user_id: user.id
      can :read, Assignment, classroom: { enrollments: { user_id: user.id } }
      can [ :new, :create ], Submission
      can :read, Submission, assignment: { classroom: { enrollments: { user_id: user.id } } }
      can :edit, Submission, assignment: { classroom: { enrollments: { user_id: user.id } } }
      can :update, Submission, assignment: { classroom: { enrollments: { user_id: user.id } } }
      can :read, Comment, commentable_type: "Assignment", commentable: { classroom: { enrollments: { user_id: user.id } } }
      can [:new, :create], Comment, commentable_type: "Assignment"
      can :read, Comment, commentable_type: "Submission", commentable: { user_id: user.id }
      can [:new, :create], Comment, commentable_type: "Submission"


    end

    can :create, User do |user_param|
      user_param.role != "admin"
    end
  end
end
