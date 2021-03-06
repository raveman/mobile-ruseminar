class LectorsController < ApplicationController
  before_action :authenticate_admin!, :except => [:index]
  before_action :set_lector, only: [:show, :edit, :update, :destroy]

  # GET /lectors
  # GET /lectors.json
  def index
    respond_to do |format|
      format.html do
        if admin_signed_in?
          @lectors = Lector.all
        else 
          authenticate_admin!
        end
      end
      format.json { @lectors = Lector.all }
    end
  end

  def import
    if !admin_signed_in?
      authenticate_admin!
      return
    end

    file = params[:lector_import_file]
    if file.nil?
      redirect_to admin_url, alert: "No file uploaded!"
      return
    end

    import_result = Lector.import(file)
    if !import_result.empty?
      import = Import.new(date: Date.today, file: file.original_filename)
      import.save!
      redirect_to admin_url, notice: "Lector import: #{import_result[0]} lectors added, #{import_result[1]} lectors updated, file: #{import.file}"
    else
      redirect_to admin_url, alert: "You have uploaded incorrect or empty file!"
    end
  end

  # GET /lectors/1
  # GET /lectors/1.json
  def show
    if !admin_signed_in?
      authenticate_admin!
      return
    end
  end

  # GET /lectors/new
  def new
    @lector = Lector.new
  end

  # GET /lectors/1/edit
  def edit
  end

  # POST /lectors
  # POST /lectors.json
  def create
    @lector = Lector.new(lector_params)

    respond_to do |format|
      if @lector.save
        format.html { redirect_to @lector, notice: 'Lector was successfully created.' }
        format.json { render :show, status: :created, location: @lector }
      else
        format.html { render :new }
        format.json { render json: @lector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lectors/1
  # PATCH/PUT /lectors/1.json
  def update
    respond_to do |format|
      if @lector.update(lector_params)
        format.html { redirect_to @lector, notice: 'Lector was successfully updated.' }
        format.json { render :show, status: :ok, location: @lector }
      else
        format.html { render :edit }
        format.json { render json: @lector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lectors/1
  # DELETE /lectors/1.json
  def destroy
    @lector.destroy
    respond_to do |format|
      format.html { redirect_to lectors_url, notice: 'Lector was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lector
      @lector = Lector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lector_params
      params.require(:lector).permit(:first_name, :father_name, :last_name, :bio, :photo_url)
    end
end
