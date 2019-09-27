clc;clear

name = {'MagicTrackPad'; 'HHKB'; 'DellScreen'; 'ScreenBarPlus'; 'XiaomiLight'};
price = {973; 2400; 3600; 999; 269};
ColName = {'Profuct_Name', 'Price'};
Price_table = table(name, price, 'VariableNames', ColName);

Total_cost = sum(cell2mat(Price_table.Price));







