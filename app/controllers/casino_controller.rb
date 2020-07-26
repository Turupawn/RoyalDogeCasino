class CasinoController < ApplicationController
  def withdraw_superplus
    self.withdraw_superplus
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
    def withdraw_superplus
      players_coins = Player.all.reduce(0) {|sum,p| sum+get_balance(p)}
      superplus = (players_coins-get_server_balance).abs
      amount_withdraw = (superplus*SUPERPLUS_PERCENTAGE_TO_WITHDRAW).round()
      client = DogecoinClient.new
      if client.valid? and superplus>CHEST_COST*10
        client.send_to_address(DP7vQa64cjZtkJ9iFJUDDEtMq8frpqgMUr, amount_withdraw - TAX_FEE)
        puts "withdraw:"+amount_withdraw-TAX_FEE
      end
    end
end
