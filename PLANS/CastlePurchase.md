CastleServerService would ofc hold all the data for how much each progression would cost. CastleServerService would also hold functions like AttemptProgressionPurchase(player: Player, progression: string) which does:

1) itll attempt to check if player actually has enough money to purchase it thru CurrencyServerService
2) if success, subtract money thru CurrenyServerService and tick that certain progression as unlocked in DataServerService thru its own methods, also add the progression in internal cache of castle data