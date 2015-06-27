module Gyms
  class AppointmentsController < BaseController
    before_action :verify_auth_token, only: [:appoint, :confirm, :comment]
    #预约概况
  end
end
