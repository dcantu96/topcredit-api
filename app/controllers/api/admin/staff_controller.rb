class Api::Admin::StaffController < Api::AuthorizedController
  before_action :is_admin

  def index
    staff_users =
      User.select(
        :id,
        :first_name,
        :last_name,
        :email,
        :created_at
      ).with_any_role(
        :admin,
        :requests,
        :pre_authorizations,
        :authorizations,
        :dispersions,
        :payments
      )

    custom_staff_users =
      staff_users.map do |user|
        {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          created_at: user.created_at,
          roles: user.all_roles
        }
      end

    render json: { data: custom_staff_users }
  end

  def show
    staff_user =
      User.select(:id, :first_name, :last_name, :email, :created_at).find(
        params[:id]
      )

    render json: {
             data: {
               id: staff_user.id,
               first_name: staff_user.first_name,
               last_name: staff_user.last_name,
               email: staff_user.email,
               created_at: staff_user.created_at,
               roles: staff_user.all_roles
             }
           }
  end

  def create
    binding.pry

    render json: staff, status: :created
  end

  private

  def is_admin
    return if current_user.nil? || !current_user.has_role?(:admin)
  end

  def staff_params
    params.require(:user).permit(:email, :first_name, :last_name, :roles)
  end
end
