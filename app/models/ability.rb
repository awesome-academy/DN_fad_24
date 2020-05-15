class Ability
  include CanCan::Ability

  def initialize user, controller_namespace
    return unless user.present?
    case controller_namespace
    when Settings.ability
      can :manage, :all if user.admin?
    else
      can [:show], User, user_id: user.id
      can [:new, :create], [Contact, Order]
    end
  end
end
