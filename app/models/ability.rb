class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    # user ||= User.new # guest user (not logged in)
    if user
      if user.account? :admin
        can :view_certificate, Course do |course|
          !Certificate.where(course_id: course.id, user_id: user.id).empty?
        end
        can :purchase_certificate, Course do |course|
          Certificate.where(course_id: course.id, user_id: user.id).empty? &&
          course.my_status(user) =~ /Quiz(zes)? Complete/
        end
        can :view_handout, Course do |course|
          !course.handout.file.nil?
        end
        can :create, Course
        can :update, Course
        can :destroy, Course
        can :take, Course
        can :manage, Quiz
        can :manage, Section
        can :manage, Video
        can :manage, User
      elsif user.account? :member
        can :take, Course, released: true
        can :view_handout, Course do |course|
          course.released && !course.handout.file.nil?
        end
        can :view_certificate, Course do |course|
          course.my_status(user) == "Course Completed! Certificate Purchased."
        end
        can :purchase_certificate, Course do |course|
          Certificate.where(course_id: course.id, user_id: user.id).empty? &&
          course.my_status(user) =~ /Quiz(zes)? Complete/
        end
      end
      
    # users who are not logged in can view courses  
    else
      can :view, Course
    end
  end
end
