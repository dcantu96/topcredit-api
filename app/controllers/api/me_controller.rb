class Api::MeController < Api::AuthorizedController
  def me
    render json: {
             id: current_user.id,
             email: current_user.email,
             firstName: current_user.first_name,
             lastName: current_user.last_name,
             roles: current_user.all_roles,
             hrCompanyId: current_user.hr_company_id
           }
  end
end
