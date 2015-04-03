class VersionController < ApplicationController
  def index
    render json: {
               code: 1,
               data: {
                   ver: '1.1.2',
                   force: 1
               }
           }
  end

  def download
    render json: {}
  end
end
