class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find_by_slug(params[:id])
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find_by_slug(params[:id])
    authorize! :update, @course, message: "You don't have access to edit this course."
  end

  def create
    @course = Course.new(course_params)
    authorize! :create, @course, message: "You don't have access to create this course." 
    
    if @course.save
      flash[:notice] = "Course was created successfully."
      redirect_to @course
    else
      flash[:error] = "Error creating course. Please try again."
      render :new
    end
  end

  def update
     @course = Course.find_by_slug(params[:id])
     authorize! :update, @course, message: "You don't have access to update this course."
     
     if @course.update_attributes(course_params)
       redirect_to @course, notice: "Course has been updated."
     else
       flash[:error] = "Error saving course.  Please try again."
       render :edit
     end
  end

  def destroy
    @course = Course.find_by_slug(params[:id])
    authorize! :destroy, @course, message: "You don't have acccess to delete this course."
    name = @course.name
    if @course.destroy
      flash[:notice] = "\"#{name}\" was deleted successfully."
      redirect_to root_path
    else
      flash[:error] = "There was an error deleting the course"
      render :show
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, :price, :user_id)
  end

end
