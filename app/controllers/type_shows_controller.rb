class TypeShowsController < ApplicationController
  def show
    @show = TypeShow.find_by(id: params[:id])
    render layout: 'news'
  end
end
