class PostsController < ApplicationController
    before_action :find_post, only: [:show, :destroy, :update]
    #this blocks 422 error. Necessary because Rails app generated without -api flag
    skip_before_action :verify_authenticity_token

    def index 
        posts = Post.all
        render json: posts.to_json
    end

    def show 
        render json: @post.to_json, include: :comments
    end

    def create 
        byebug
        post = Post.create(post_params)
        if post.valid?
            render json: post.to_json, status: :created
        else
            render json: { error: 'failed to create post' }, status: :not_acceptable
        end
    end

    def update
        @post.update(post_params)
        if @post.valid?
            render json: @post.to_json
        else
            render json: { error: 'failed to edit post' }, status: :not_acceptable
        end
    end

    def destroy 
        @post.destroy
        render json: { confirmation: 'deleted!' } 
    end

    private

    def post_params
        params.require(:post).permit(:positive, :negative, :severe, :category, :poster_id)
    end

    def find_post
        @post = Post.find(params[:id])
    end

end