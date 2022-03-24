class User::FiltersController < User::BaseController
  def index
    @filters = current_user.filters.page(params[:page])
    @filter_count = @filters.total_count
  end

  def new
    @filter = current_user.filters.build
  end

  def create
    @filter = current_user.filters.build(params.require(:filter).permit(:comparison, :value))

    respond_to do |format|
      if @filter.save
        format.html { redirect_to user_filters_path, notice: "Filter saved." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @filter = current_user.filters.find(params[:id])
  end

  def update
    @filter = current_user.filters.find(params[:id])

    respond_to do |format|
      if @filter.update(params.require(:filter).permit(:comparison, :value))
        format.html { redirect_to user_filters_path, notice: "Filter saved." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    filter = current_user.filters.find(params[:id])
    filter.destroy
    redirect_to user_filters_path, notice: "Filter removed."
  end
end
