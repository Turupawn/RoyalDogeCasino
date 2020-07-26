class CasinoController < ApplicationController
  def withdraw_superplus
    players_coins = Player.reduce(0) {|sum,p| sum+get_balance(p)}
    puts players_coins-get_server_balance
  end
  private
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
    def get_server_balance
      client = DogecoinClient.new
      balance = 0
      return balance = client.get_balance
    end
end
