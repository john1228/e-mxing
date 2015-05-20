class TypeShowsController < ApplicationController
  def show
    @show = TypeShow.find_by(id: params[:id])
    @cc = params[:cc]
    render layout: 'type_show'
  end
end
