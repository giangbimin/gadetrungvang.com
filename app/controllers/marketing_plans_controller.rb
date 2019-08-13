class MarketingPlansController < ApplicationController
  before_action :set_marketing_plan, only: [:show, :edit, :update, :destroy]

  # GET /marketing_plans
  # GET /marketing_plans.json
  def index
    @marketing_plans = MarketingPlan.all
  end

  # GET /marketing_plans/1
  # GET /marketing_plans/1.json
  def show
  end

  # GET /marketing_plans/new
  def new
    @marketing_plan = MarketingPlan.new
  end

  # GET /marketing_plans/1/edit
  def edit
  end

  # POST /marketing_plans
  # POST /marketing_plans.json
  def create
    @marketing_plan = MarketingPlan.new(marketing_plan_params)

    respond_to do |format|
      if @marketing_plan.save
        format.html { redirect_to @marketing_plan, notice: 'Marketing plan was successfully created.' }
        format.json { render :show, status: :created, location: @marketing_plan }
      else
        format.html { render :new }
        format.json { render json: @marketing_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marketing_plans/1
  # PATCH/PUT /marketing_plans/1.json
  def update
    respond_to do |format|
      if @marketing_plan.update(marketing_plan_params)
        format.html { redirect_to @marketing_plan, notice: 'Marketing plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @marketing_plan }
      else
        format.html { render :edit }
        format.json { render json: @marketing_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marketing_plans/1
  # DELETE /marketing_plans/1.json
  def destroy
    @marketing_plan.destroy
    respond_to do |format|
      format.html { redirect_to marketing_plans_url, notice: 'Marketing plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketing_plan
      @marketing_plan = MarketingPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketing_plan_params
      params.require(:marketing_plan).permit(:plan_name, :subject, :html_plain, :text_plain)
    end
end
