class GeneralCausasController < ApplicationController
  before_action :set_general_causa, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @general_causas = GeneralCausa.all
    respond_with(@general_causas)
  end

  def show
    respond_with(@general_causa)
  end

  def new
    @general_causa = GeneralCausa.new
    respond_with(@general_causa)
  end

  def edit
  end

  def create
    @general_causa = GeneralCausa.new(general_causa_params)
    @general_causa.save
    respond_with(@general_causa)
  end

  def update
    @general_causa.update(general_causa_params)
    respond_with(@general_causa)
  end

  def destroy
    @general_causa.destroy
    respond_with(@general_causa)
  end

  private
    def set_general_causa
      @general_causa = GeneralCausa.find(params[:id])
    end

    def general_causa_params
      params.require(:general_causa).permit(:rol, :date, :caratulado, :tribunal)
    end
end
