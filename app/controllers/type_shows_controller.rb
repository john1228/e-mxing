class TypeShowsController < ApplicationController
  def show
    @show = TypeShow.find_by(id: params[:id])
    @cc = params[:cc]
    @created = @show.created_at.localtime.strftime('%m-%d %H:%M')
    render layout: 'type_show'
  end
end
