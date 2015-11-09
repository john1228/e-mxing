module Api
  module Dynamics
    class HomeController < ApplicationController
      before_filter :fetch_user, only: [:show, :index]
      before_filter :auth_user, only: [:create, :destroy]

      def index
        render json: Success.new(
                   dynamic: @user.dynamics.order(created_at: :desc).page(params[:page]||1).map { |dynamic|
                     {
                         id: dynamic.id,
                         content: HarmoniousDictionary.clean(dynamic.content || ''),
                         image: dynamic.dynamic_images.map { |image| {url: image.image.url} },
                         film: {cover: (dynamic.dynamic_film.cover.url rescue ''), film: (dynamic.dynamic_film.film.hls rescue '')},
                         created: dynamic.created_at.to_i,
                         likes: dynamic.likes.count,
                         like_user: dynamic.likes.includes(:user).order(id: :desc).limit(15).map { |like| {
                             user: {
                                 mxid: like.user.profile.mxid,
                                 name: like.user.profile.name,
                                 avatar: like.user.profile.avatar.url,
                                 age: like.user.profile.age,
                                 gender: like.user.profile.gender,
                                 identity: Profile.identities[like.user.profile.identity],
                             },
                             created: like.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                         } },
                         comments: {
                             count: dynamic.dynamic_comments.count,
                             item: dynamic.dynamic_comments.order(id: :desc).limit(2).collect { |comment|
                               {
                                   content: HarmoniousDictionary.clean(comment.content),
                                   created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                                   user: {
                                       mxid: comment.user.profile.mxid,
                                       name: comment.user.profile.name,
                                       avatar: comment.user.profile.avatar.url,
                                       age: comment.user.profile.age,
                                       gender: comment.user.profile.gender,
                                       identity: Profile.identities[comment.user.profile.identity],
                                   },
                               }
                             }
                         }
                     }
                   }
               )
      end

      def show
        dynamic = Dynamic.find(params[:id])
        if dynamic.present?
          render json: Success.new(dynamic: {
                                       id: dynamic.id,
                                       content: HarmoniousDictionary.clean(dynamic.content || ''),
                                       image: dynamic.dynamic_images.map { |image| {url: image.image.url} },
                                       film: {cover: (dynamic.dynamic_film.cover.url rescue ''), film: (dynamic.dynamic_film.film.hls rescue '')},
                                       created: dynamic.created_at.to_i,
                                       publisher: {
                                           mxid: dynamic.user.profile.mxid,
                                           name: dynamic.user.profile.name,
                                           avatar: dynamic.user.profile.avatar.url,
                                           age: dynamic.user.profile.age,
                                           gender: dynamic.user.profile.gender,
                                           identity: Profile.identities[dynamic.user.profile.identity],
                                       },
                                       likes: dynamic.likes.count,
                                       like_user: dynamic.likes.includes(:user).order(id: :desc).limit(15).map { |like| {
                                           user: {
                                               mxid: like.user.profile.mxid,
                                               name: like.user.profile.name,
                                               avatar: like.user.profile.avatar.url,
                                               age: like.user.profile.age,
                                               gender: like.user.profile.gender,
                                               identity: Profile.identities[like.user.profile.identity]
                                           },
                                           created: like.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                                       } }
                                   })
        else
          render json: Failure.new('您查看到内容已删除')
        end
      end

      def create
        dynamic = @user.dynamics.new(content: params[:content])
        (0...10).each { |image_index| dynamic.dynamic_images.build(image: params["#{image_index}"]) if params["#{image_index}"].present? }
        dynamic.build_dynamic_film(cover: params[:cover], film: params[:film]) if params[:film].present?&&params[:cover].present?
        if dynamic.save
          render json: Success.new(dynamic: {
                                       id: dynamic.id,
                                       content: HarmoniousDictionary.clean(dynamic.content || ''),
                                       image: dynamic.dynamic_images.map { |image| {url: image.image.url} },
                                       film: {cover: (dynamic.dynamic_film.cover.url rescue ''), film: (dynamic.dynamic_film.film.hls rescue '')},
                                       created: dynamic.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S'),
                                   })
        else
          render json: Failure.new(message: '发布动态失败:' + dynamic.errors.messages.values.join(';'))
        end
      end

      def destroy
        dynamic = @user.dynamics.find_by(id: params[:id])
        if dynamic.nil?
          render json: Failure.new('该动态已经被删除')
        else
          if dynamic.destroy
            render json: Success.new
          else
            render json: Failure.new(message: '发布动态失败:' + dynamic.errors.messages.values.join(';'))
          end
        end
      end

      private
      def fetch_user
        @user = User.find_by_mxid(params[:mxid])|| Rails.cache.fetch(request.headers[:token])
        render json: Failure.new('您查看的用户不存在') if @user.nil?
      end

      def auth_user
        @user = Rails.cache.fetch(request.headers[:token])
        render json: Failure.new(-1, '您还未登录') if @user.nil?
      end
    end
  end
end
