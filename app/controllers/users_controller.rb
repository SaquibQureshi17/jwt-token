class UsersController < ApplicationController
  before_action :authorize_request,  only: [ :show, :update, :index, :destroy  ]
  before_action :find_user, only: [ :show, :update, :destroy ]

  def index 
    @user = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
      status: :unprocessable_entity
    end
  end

  def update 
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_message }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find_by_username!(params[:username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(
      :avatar, :name, :username, :email, :password, :password_confirmation
    )
  end

end
