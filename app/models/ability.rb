class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # invitado

    if user.respond_to?(:admin?) && user.admin?
      can :manage, :all
      return
    end

    # Reglas comunes para usuarios logueados
    if user.persisted?
      # Puede crear schedules (como cliente)
      can :create, Schedule

      # Puede ver/editar/eliminar sus propios schedules como cliente
      can [ :read, :update, :destroy ], Schedule, user_id: user.id
    end

    # Si el usuario también es entrenador (ajusta a tu lógica real)
    if user.respond_to?(:trainer?) && user.trainer?
      can :read,   Schedule, trainer_id: user.id
      can :update, Schedule, trainer_id: user.id
      # decide si puede :destroy o :create también como entrenador
    end

    # Invitados (no logueados) — solo lectura pública si quieres
    # can :read, Schedule, status: :confirmed
  end
end
