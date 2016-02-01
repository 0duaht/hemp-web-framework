class FellowsController < Hemp::BaseController
  def index
    @fellows = Fellow.all
  end

  def new
  end

  def create
    Fellow.create(fellow_params)
    redirect_to "/"
  end

  def update
    fellow.first_name = params[:first_name]
    fellow.last_name = params[:last_name]
    fellow.email = params[:email]
    fellow.stack = params[:stack]

    fellow.save
    redirect_to "/"
  end

  def show
    fellow
  end

  def destroy
    fellow.destroy
    redirect_to "/"
  end

  def fellow_params
    params.to_h.slice(:first_name, :last_name, :email, :stack)
  end

  def fellow
    @fellow ||= Fellow.find(params[:id].to_i)
  end
end
