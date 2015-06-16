class WalletLog < ActiveRecord::Base
  ACTIONS = {income: 1, withdraws: 2}
end
