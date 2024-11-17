class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[show edit update destroy]
  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(params_user)
    begin
      @user.save!
      auto_login(@user)
      flash[:notice] = "アカウント作成しました"
      redirect_to line_official_path
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] ="アカウント作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user.update!(params_user)
    flash[:notice] = "ユーザー情報を更新しました"
    redirect_to user_path
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] ="ユーザー情報の更新に失敗しました"
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @user.destroy!
    flash[:alert] = "アカウントを削除しました"
    redirect_to root_path
  rescue ActiveRecord::RecordNotDestroyed
    flash[:alert] ="アカウント削除に失敗しました もう一度試してください"
    redirect_to posts_path
  end

  def post
    @posts = current_user.posts.all.order("created_at DESC").page(params[:page])
  end

  def like_post
    @posts = Post.includes(:user, :like_posts).where(like_posts: { user_id: current_user.id }).order("like_posts.created_at DESC").page(params[:page])
  end

  private

  def params_user
    params.require(:user).permit(:name, :email, :instagram_account_url, :password, :password_confirmation, :avatar, :avatar_cache)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
