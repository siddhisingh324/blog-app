# app/controllers/api/v1/blogs_controller.rb

module Api
  module V1
    class BlogsController < Api::V1::ApiController
      before_action :authenticate_request
      before_action :set_blog, only: [:update, :show, :destroy]

      def create
        @blog = current_user.blogs.new(blog_params)
        if @blog.save
          render_success_response(@blog, I18n.t('blog.single_blog'), status = 200)
        else
          render_unprocessable_entity_response(@blog)
        end
      end

      def index
        blogs = current_user.blogs
        render_success_response({
          blogs: array_serializer.new(blogs, serializer: BlogSerializer)
        }, I18n.t('blog.all_blogs'), status = 200)
      end

      def show
        render_success_response({
          blog: single_serializer.new(@blog, serializer: BlogSerializer)
        }, I18n.t('blog.show'), status = 200)
      end

      def update
        if @blog.update(blog_params)
          render_success_response({
            blog: single_serializer.new(@blog, serializer: BlogSerializer)
          }, I18n.t('blog.updated'))
        else
          render_unprocessable_entity_response(@blog)
        end
      end

      def destroy
        if @blog.destroy
          render_success_response(@blog, I18n.t('blog.destroy'), status = 200)
        else
          render_unprocessable_entity_response(@blog)
        end
      end

      private

      def blog_params
        params.require(:blog).permit(:title, :description)
      end

      def set_blog
        @blog = current_user.blogs.find_by(id: params[:id])
        render_unprocessable_entity(I18n.t('blog.not_found')) if !@blog.present?
      end
    end
  end
end
