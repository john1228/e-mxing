ActiveAdmin.register ServicePhoto do
  menu label: '照片牆'
  config.filters = false
  belongs_to :service
  navigation_menu :service
  actions :index, :upload, :delete

  permit_params :photo

  controller do
    def index
      @service = Service.find_by(id: params[:service_id])
      @photos = @service.photos
      render layout: 'active_admin'
    end

    def upload
      service = Service.find_by(id: params[:service_id])
      photo = service.photos.new(photo: params[:image])
      if photo.save
        logger.info photo.id
      end
      redirect_to admin_service_service_photos_path(service)
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
