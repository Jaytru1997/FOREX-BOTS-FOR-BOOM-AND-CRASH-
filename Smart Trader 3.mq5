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

string Check_RSI_Entry();
void close_orders();   //declare the function for closing orders
void close_trade(); //declare the function for closing trades
double     peak_profit=0; //the max profit reached
double     now_profit=0;   //the current profit
int total_orders=0;
input double     max_loss=10;
input int period = 6;
input double take_profit=100;
bool second_range=false;
  

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  //open_buy();
  Comment("Smart Trader 2.0 added to Chart");
  EventSetMillisecondTimer(40);
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

void open_buy()
   {
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits); //Get the ask price
   MqlRates price_info[];  //Array for prices
   ArraySetAsSeries(price_info, true);    //Sort the price array from the current candle downwards
   int PriceData =CopyRates(_Symbol,_Period,0,3,price_info);   //Fill the array with the price data
   if (price_info[1].close > price_info[1].open)
   if (PositionsTotal()==0)
      {
      trade.Buy(10.0,NULL,Ask,Ask-10000*_Point,Ask+10000*_Point,NULL);
      }
      
   }

void close_trade(string symbol)     //Function for closing a trade using it symbol pair
   {
   trade.PositionClose(symbol);
   }

void close_orders()        //close all orders including pending ones 
   {
   total_orders = OrdersTotal();
   
   for (int i=total_orders-1; i>=0; i--)
      {
      ulong order_ticket= OrderGetTicket(i);
      string symbol = OrderGetString(ORDER_SYMBOL);
      
      if ((order_ticket!=0) && (symbol==_Symbol))
         {
         trade.OrderDelete(order_ticket);
         }
      
      }
   
   }

double Check_RSI_Entry(string symbol)
   {
   //create a string for the signal
   string signal="";
   double myRSIArray[]; //create an array for the price date
   int myRSIDefinition= iRSI(symbol,_Period,period,PRICE_CLOSE);  //define the properties of the RSI
   ArraySetAsSeries(myRSIArray, true);    //sort the price array from the current candle downward
   CopyBuffer(myRSIDefinition,0,0,3,myRSIArray);  //Defined EA from current candle for 3 candles save in array
   double myRSIValue= NormalizeDouble(myRSIArray[0],2);  //the current current RSI value
   return myRSIValue;
   }


      
void OnTimer()
  {
   string chart_symbol = Symbol();      // get chart's current symbol pair\
   
   //check if the symbol pair on the chart has an open position
   if (PositionSelect(chart_symbol)==true)
   {
     
            string position_symbol=PositionGetString(POSITION_SYMBOL);
            if (position_symbol==chart_symbol) //if the current chart has an open position
            {
               double position_profit= PositionGetDouble(POSITION_PROFIT); //get current position profit
               double position_swap= PositionGetDouble(POSITION_SWAP);
               
               now_profit= position_profit + position_swap;
         
      
               if (now_profit>=peak_profit)
                  {
                  peak_profit=now_profit;
                  }
               
               
               //MONITOR RSI
               double myRSIValue=Check_RSI_Entry(chart_symbol);
               
   
          
               
               
               Comment(
                     "Current RSI period  ",myRSIValue,"\n",
                     "Position symbol  ",position_symbol,"\n",
                     "Position peak profit  ",peak_profit,"\n",
                     "Position profit  ",position_profit,"\n",
                     "Position swap   ",position_swap,"\n",                    
                     "Position net profit  ",now_profit,"\n"
                     );
                     
               if ((myRSIValue>9.5 && myRSIValue<10.5) || (myRSIValue>19.5 && myRSIValue<20.5) || (myRSIValue>79.5 && myRSIValue<80.5))
                  {
                  close_trade(position_symbol);
                  close_orders();
                  return;
                  }
               if (second_range=true)
                  {
                     if (position_profit>=take_profit)
                        {
                           close_trade(position_symbol);
                           close_orders();
                           second_range=false;
                        }
                  }
                  
               
               double drop;
   
               if (peak_profit>0)
                  {
                     drop=peak_profit-now_profit;
   
                     if (drop>=(0.5*peak_profit))
                     {
                        if (position_profit>0)
                           {
                              close_trade(position_symbol);
                              close_orders();
                              return;
                           }
                        else
                        {
                        second_range=true;
                        return;
                        }
                     }
                  }
   
               if (peak_profit==0)
                  {
                     drop=peak_profit-now_profit;
      
                     if (drop>=max_loss)
                        {
                        close_trade(position_symbol);
                        close_orders();
                        }
                  }
   
            
         }
   
   
   }
   else
   {
   peak_profit=0;
   second_range=false;
   }
  }

