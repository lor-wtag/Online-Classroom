# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, Classroom
      can :manage, Enrollment
    elsif user.teacher?
      can :manage, Classroom, user_id: user.id
      can :destroy, Enrollment, classroom: { user_id: user.id }
    elsif user.student?
      can :read, Classroom, enrollments: { user_id: user.id }
      can :join, Classroom
      can :enroll, Classroom
      can :destroy, Enrollment, user_id: user.id
    end
  end
end
