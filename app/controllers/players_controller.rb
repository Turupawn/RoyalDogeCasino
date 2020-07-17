class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def open_chest
    @player = Player.find_by_id(params['player']['id'])
    # TODO: Open chest logic
    @balance = 2500
    @result = rand(10)
    render "show"
  end

  def cashout
    @player = Player.find_by_id(params['player']['id'])
    # TODO: Cashout logic
    @balance = 2500
    render "show"
  end

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
    # Todo: Handle repeated code?
    @balance = 2500
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    existing_player = Player.find_by_cashout_address(player_params[:cashout_address])

    if existing_player
      respond_to do |format|
        format.html { redirect_to existing_player, notice: 'Existing player found.' }
        format.json { render :show, status: :created, location: existing_player }
      end
    else
      @player = Player.new(player_params)

      # TODO: set @player.deposit_address

      respond_to do |format|
        if @player.save
          format.html { redirect_to @player, notice: 'Player was successfully created.' }
          format.json { render :show, status: :created, location: @player }
        else
          format.html { render :new }
          format.json { render json: @player.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:deposit_address, :cashout_address, :result)
    end
end
