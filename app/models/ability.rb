# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    cannot :read, User unless user.admin?
    if user.admin?
      can :manage, :all
      can :create, User
    elsif user.teacher?
      can [:read, :edit, :update, :delete, :destroy ], User, id: user.id
      can :manage, Classroom, user_id: user.id
      can :destroy, Enrollment, classroom: { user_id: user.id }
      can :manage, Assignment, classroom: { user_id: user.id }
    elsif user.student?
      can [ :read, :edit, :update, :delete, :destroy ], User, id: user.id
      can :read, Classroom, enrollments: { user_id: user.id }
      can :create, Enrollment, user_id: user.id
      can :create_enrollment, Classroom, user_id: user.id
      can :join, Classroom
      can :enroll, Classroom
      can :destroy, Enrollment, user_id: user.id
      can :read, Assignment, classroom: { enrollments: { user_id: user.id } }
    end

    can :create, User do |user_param|
      user_param.role != "admin"
    end
  end
end
