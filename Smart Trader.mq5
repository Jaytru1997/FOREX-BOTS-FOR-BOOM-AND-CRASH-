//+------------------------------------------------------------------+
//|                                                 Smart Trader.mq5 |
//|                                        Copyright 2020,STARMINDS. |
//|                                    https://www.starmindsblog.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020,STARMINDS."
#property link      "https://www.starmindsblog.com"
#property version   "1.00"

//include neccessary library for opening and closing trades
#include<Trade\Trade.mqh>

//create an instance of Ctrade
CTrade  trade;

//--- input parameters

void close_trade(); //declare the function for closing trades
double     peak_profit=0; //the max profit reached
double     now_profit=0;   //the current profit
input double     max_loss=10;
input int take_profit=20;  

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  Comment("Smart Trader 2.0 added to Chart");
  EventSetMillisecondTimer(100);
  return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  Comment("Smart Trader 2.0 removed from Chart");
  EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void close_trade(ulong ticket)     //Function for closing a trade using it ticket number
   {
   //trade.PositionClose(ticket);
   }
   
void OnTick()
  {
   //MqlTick myprice;
   string chart_symbol = Symbol();      // get chart's current symbol pair\
  
   //int ticket= PositionGetTicket();
   
   //now_profit=SymbolInfoTick(chart_symbol,myprice);   // get current profit for current chart symbol
   
   //check if the symbol pair on the chart has an open position
   if (PositionSelect(chart_symbol)==true)
   {
      for (int i=PositionsTotal()-1; i>=0; i--) //count the number of open positions
         {
            string position_symbol=PositionGetString(POSITION_SYMBOL);
            if (position_symbol==chart_symbol)
            {
               ulong position_ticket= PositionGetTicket(i); //get the position ticket number
               double position_profit= PositionGetDouble(POSITION_PROFIT); //get current position profit
               double position_swap= PositionGetDouble(POSITION_SWAP);
               //string position_symbol=PositionGetString(POSITION_SYMBOL);
               now_profit= position_profit + position_swap;
         
      
               if (now_profit>=peak_profit)
                  {
                  peak_profit=now_profit;
                  }
               
               Comment(
                     "Position ticket  ",position_ticket,"\n",
                     "Position symbol  ",position_symbol,"\n",
                     "Position peak profit  ",peak_profit,"\n",
                     "Position profit  ",position_profit,"\n",
                     "Position swap   ",position_swap,"\n",                    
                     "Position net profit  ",now_profit,"\n"
                     ); 
      
   
               double drop;
   
               if (peak_profit>0)
                  {
                     drop=peak_profit-now_profit;
   
                     if (drop>=(cutoff_ratio*peak_profit))
                     {
                        close_trade(position_ticket);
                     }
                  }
   
               if (peak_profit==0)
                  {
                     drop=peak_profit-now_profit;
      
                     if (drop>=max_loss)
                        {
                        close_trade(position_ticket);
                        }
                  }
    
               if (peak_profit<0)
                  {
                     drop=peak_profit-now_profit;
      
                     if (drop>=(cutoff_ratio*peak_profit))
                  {
                     close_trade(position_ticket);
                  }
                  }
            }
         }
   
   
   }
   else
   {
   peak_profit=0;
   }
  }

