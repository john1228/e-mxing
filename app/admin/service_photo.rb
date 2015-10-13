ActiveAdmin.register ServicePhoto do
  menu label: '照片牆'
  config.filters = false
  belongs_to :service
  navigation_menu :service

  permit_params :photo

  controller do
    def index
      @service = Service.find_by(id: params[:service_id])
      @photos = @service.photos
      render layout: 'active_admin'
    end

    def create
      service = Service.find_by(id: params[:service_id])
      service.photos.create(photo: params[:file_data], loc: params[:file_id])
      render json: {}
    end

    def delete
      service = Service.find_by(id: params[:service_id])
      photo = service.photos.find_by(id: params[:key])
      if photo.destroy
        render json: {}
      else
        render json: {}
      end
    end
  end
end
