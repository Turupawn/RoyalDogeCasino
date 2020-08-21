class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def open_chest
    @player = Player.find_by_id(params['player']['id'])

    @balance = get_balance @player

    if @balance < CHEST_COST
      respond_to do |format|
        format.html { redirect_to @player, notice: 'Not enough balance.' }
      end
      return
    end

    @chest = Chest.new
    @chest.player_id = @player.id
    @chest.cost = CHEST_COST
    rewards = [10,7,7,6,6,4,4,3,3,3,1]
    @reward = rewards[rand(11)]
    @chest.reward = @reward

    @balance -= @chest.cost
    @balance += @chest.reward

    @chest.save

    render "show"
  end

  def cashout
    @player = Player.find_by_id(params['player']['id'])
    @balance = get_balance @player

    if @balance < 2
      respond_to do |format|
        format.html { redirect_to @player, notice: 'Not enough balance for cashout.' }
      end
      return
    end

    client = DogecoinClient.new
    if client.valid?
      client.send_to_address(@player.cashout_address, @balance - TAX_FEE)
    else
      # TODO: Handle invalid dogecoin client
    end

    @withdraw = Withdraw.new
    @withdraw.player_id = @player.id
    @withdraw.amount = @balance
    @withdraw.save

    respond_to do |format|
      format.html { redirect_to @player, notice: 'You just cashed out.' }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @balance = get_balance @player
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # POST /players
  # POST /players.json
  def create
    existing_player = Player.find_by_cashout_address(player_params[:cashout_address])
    client = DogecoinClient.new
    
    if client.valid?
     client.validate_address(player_params[:cashout_address])
     puts client.validate_address(player_params[:cashout_address])
    else
     # TODO: Handle invalid client
     puts "not valid"
    end

    if existing_player
      respond_to do |format|
        format.html { redirect_to existing_player, notice: 'Existing player found.' }
        format.json { render :show, status: :created, location: existing_player }
      end
    else
      @player = Player.new(player_params)
      
      if client.valid?
        @player.deposit_address = client.get_new_address
      else
        # TODO: Handle invalid client
      end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find_by_hashid(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:deposit_address, :cashout_address, :result)
    end

    def get_balance player
      client = DogecoinClient.new
      balance = 0
      if client.valid?
        balance += client.get_received_by_address(player.deposit_address)
      else
        # TODO: Handle invalid client
      end
      player.withdraws.each do |withdraw|
        balance-=withdraw.amount
      end
      player.chests.each do |chest|
        balance-=chest.cost
        balance+=chest.reward
      end
      return balance
    end
end
