class Api::Admin::StaffController < Api::AuthorizedController
  before_action :is_admin
  before_action :set_staff_user, only: %i[update show]

  def index
    render json: {
             data:
               User
                 .includes(:roles) # Eager-load roles
                 .staff
                 .map do |user|
                   {
                     id: user.id,
                     first_name: user.first_name,
                     last_name: user.last_name,
                     email: user.email,
                     created_at: user.created_at,
                     roles: user.all_roles
                   }
                 end
           }
  end

  def show
    render json: {
             data: {
               id: @staff_user.id,
               first_name: @staff_user.first_name,
               last_name: @staff_user.last_name,
               email: @staff_user.email,
               created_at: @staff_user.created_at,
               roles: @staff_user.all_roles,
               hr_company_id: @staff_user.hr_company_id
             }
           }
  end

  def create
    staff_user = User.new(staff_params)

    if staff_user.save
      render json: {
               data: {
                 id: staff_user.id,
                 first_name: staff_user.first_name,
                 last_name: staff_user.last_name,
                 email: staff_user.email,
                 created_at: staff_user.created_at,
                 roles: staff_user.all_roles,
                 hr_company_id: @staff_user.hr_company_id
               }
             },
             status: :created
    else
      render json: {
               errors: staff_user.errors.full_messages
             },
             status: :unprocessable_entity
    end
  end

  def update
    if @staff_user.update(staff_params.except(:roles))
      update_user_roles(@staff_user, staff_params[:roles])

      render json: {
               data: {
                 id: @staff_user.id,
                 first_name: @staff_user.first_name,
                 last_name: @staff_user.last_name,
                 email: @staff_user.email,
                 created_at: @staff_user.created_at,
                 roles: @staff_user.all_roles,
                 hr_company_id: @staff_user.hr_company_id
               }
             },
             status: :ok
    else
      render json: {
               errors: staff_user.errors.full_messages
             },
             status: :unprocessable_entity
    end
  end

  private

  def is_admin
    unless current_user&.has_role?(:admin)
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def set_staff_user
    @staff_user = User.find_by(id: params[:id])
    unless @staff_user
      render json: { error: "Staff user not found" }, status: :not_found
    end
    unless @staff_user&.roles.length > 0
      render json: {
               error: "Staff user has no roles"
             },
             status: :unprocessable_entity
    end
  end

  def staff_params
    params
      .require(:data)
      .require(:attributes)
      .permit(
        :email,
        :first_name,
        :last_name,
        :created_at,
        :hr_company_id,
        roles: []
      )
  end

  def update_user_roles(user, roles)
    # Remove all existing roles
    user.roles.destroy_all

    # Add the new roles
    roles.each { |role| user.add_role(role) if role.present? }
  end
end
