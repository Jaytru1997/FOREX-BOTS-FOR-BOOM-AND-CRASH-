

The Smart Trader 2.0 is an upgraded version of Smart trader. This is aimed at minimizing losses during Boom and Crash Tradings.

Here is how it works. 
The Robot when added to a chart, monitors the prices of the symbol pair, it also calculate the profit aquired at any instance. 
The robot checks the prices of the active symbol pairs every 100 milliseconds. Whenever a spike occurs, the robot closes the 
trade as soon as possible to minimize losses, this it does within that 100 millisecond range, What this means is that it might not capture all spikes,
because some some spikes are way too sudden and fast for it to capture. Also due to System  hardware limitations, building a bot that checks prices at a quicker rate
(less than 100 milliseconds) will lead to a lot of crashes


However in a case where a sudden spikes was not captured, the bot checks if the trade is still on profit, if yes,
it closes it immediately, but if the trade profit has dropped too far, so much that it transforms to a loss, the bot waits for profits to rise 
again to a certain predefined point (Take Profit).

Also if during a trade, there was never a profit, but a loss, the bot would close that trade once the trade has acquired a certained predefined level of loss (stop lose/ max loss) 

Two parameters are adjustable

The Take profit (profit for closing trade after a very quick major spike)
The Max loss (The stop lose)


