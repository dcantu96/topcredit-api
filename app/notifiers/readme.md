# - PendingUserNotifier

# - When a user status is set to "pending"

# - Roles: :admin, :requests

# - Content: "Un nuevo cliente #{record.first_name} ha solicitado un crédito"

# - PreAuthorizationUserNotifier

# - When a user status is set to "pre-authorization"

# - Roles: :admin, :pre_authorizations, :requests

# - Content: "Solicitud del cliente #{record.first_name} aprobada por #{params[:handler_name]}"

# - DeniedUserNotifier

# - When a user status is set to "denied"

# - Roles: :admin, :pre_authorizations, :requests

# - Content: "Solicitud del cliente #{record.first_name} denegada por #{params[:handler_name]}"

# - InvalidDocumentationUserNotifier

# - When a user status is set to "invalid-documentation"

# - Roles: :admin, :requests

# - Content: "Solicitud del cliente #{record.first_name} marcada con documentación inválida por #{params[:handler_name]}"

# - PreAuthorizedUserNotifier

# - When a user status is set to "pre-authorized"

# - Roles: :admin, :pre_authorizations

# - Content: "Solicitud del cliente #{record.first_name} pre autorizada por #{params[:handler_name]}"

# Below are credit notifiers

# - PendingCreditNotifier

# - When a credit status is set to "pending"

# - Roles: :admin, :authorizations

# - Content: "Crédito del cliente #{record.first_name} está pendiente de aprobación"

# - InvalidDocumentationCreditNotifier

# - When a credit status is set to "invalid-documentation"

# - Roles: :admin, :authorizations

# - Content: "Crédito del cliente #{record.first_name} marcado con documentación inválida por #{params[:handler_name]}"

# - AuthorizedCreditNotifier

# - When a credit status is set to "authorized"

# - Roles: :admin, :dispersions, :authorizations

# - Content: "Crédito del cliente #{record.first_name} autorizado por #{params[:handler_name]}"

# - DeniedCreditNotifier

# - When a credit status is set to "denied"

# - Roles: :admin, :authorizations

# - Content: "Crédito del cliente #{record.first_name} denegado por #{params[:handler_name]}"

# - DispersedCreditNotifier

# - When a credit status is set to "dispersed"

# - Roles: :admin, :dispersions

# - Content: "Crédito del cliente #{record.first_name} dispersado por #{params[:handler_name]}"

# - Roles: :admin, :payments

# - Content: "Crédito del cliente #{record.first_name} instalado por #{params[:handler_name]}"
