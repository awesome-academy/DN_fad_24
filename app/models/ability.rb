class Ability
  include CanCan::Ability

  def initialize user
    return unless user.present?
    if user.admin?
      can :manage, :all
    else
      can [:show], User, user_id: user.id
      can [:new, :create], [Contact, Order]
    end
  end
end
