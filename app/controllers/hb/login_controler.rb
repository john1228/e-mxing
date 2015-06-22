module Hb
  class LoginController < ApplicationController
    def new
      render layout: false
    end

    def login
      render layout: false
    end
  end
end