class GroupsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path, notice:"新增文章成功。"
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to group_path, notice: "修改完畢。"
    else
      render :edit
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path, alert: "刪除完畢。"
  end

   def join
   @group = Group.find(params[:id])

   if !current_user.is_member_of?(@group)
     current_user.join!(@group)
     flash[:notice] = "已經關注此文章"
   else
     flash[:warning] = "你已經關注該文章。"
   end

   redirect_to group_path(@group)
 end

 def quit
   @group = Group.find(params[:id])

   if current_user.is_member_of?(@group)
     current_user.quit!(@group)
     flash[:alert] = "已取消關注該文章。"
   else
     flash[:warning] = "你沒有關注該文章了！"
   end

   redirect_to group_path(@group)
 end



  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
