class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Task が正常に投稿されたっすよ！'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿できないっす…。'
      render :new
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end 
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'Task はちゃんと更新されたで！'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されなかったで。なにしてるんや！'
      render :edit
    end
  end 
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    flash[:success] = 'Task は消した。永久にな。ふははははは！！'
    redirect_to tasks_url
  end 
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
